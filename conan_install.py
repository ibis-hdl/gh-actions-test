#! /usr/bin/env python3

import subprocess
import platform
import argparse
import pathlib
from multipledispatch import dispatch

class ConanInstaller:
    def __init__(self):

        match platform.system():
            case 'Linux':
                self.python = 'python3'
                self.shell = ['bash', '-c']
                self.generator = 'Ninja'
                self.valid_profiles = ['default', 'gcc', 'clang', 'clang-libc++']
            case 'Windows':
                self.python = 'py'
                self.shell = ['pwsh', '-Command']
                self.generator = "'Ninja Multi-Config'"
                self.valid_profiles = ['default', 'msvc']
            case 'Darwin':
                self.python = 'python3'
                self.shell = ['bash', '-c']
                self.generator = 'Ninja Multi-Config'
                self.valid_profiles = ['default', 'clang', 'gcc']
            case _:
                # https://docs.python.org/3/library/platform.html#platform.system
                raise Exception(f"Unsupported Platform {platform.system()}")

        self.all_build_types = ['release', 'debug']
        self.all_profiles = ['default', 'gcc', 'clang', 'clang-libc++', 'msvc', 'msvc-cl']
        parser = argparse.ArgumentParser()
        parser.add_argument("--profile", help="Conan profile used to install.",
                            type=str, choices=self.valid_profiles)
        arg = parser.parse_args()

        if arg.profile:
            self.conan_profile = arg.profile
        else:
            self.conan_profile = self.valid_profiles[0]
        print(f"using conan profile '{self.conan_profile}'")

    """
    Remove Conan generated CMake preset file.

    The generation of the e.g. 'ConanPresets.json', same as the 'CMakeUserPresets.json',
    is cumulative, it adds (include) new presets at every conan install. This may results
    into wrong includes and results into difficult to understand and irritating error
    messages. Hence, simply delete it before on each run.
    @see `conanfile.py` at generate().
    """
    def removeConanPresetsJson(self, file_name: str):
        file_path = pathlib.Path(file_name)
        if file_path.exists():
            print(f"remove former generated Conan CMake preset '{file_name}'")
            pathlib.Path(file_name).unlink(missing_ok=True)

    @dispatch(str, str)
    def install(self, build_type: str, conan_profile: str) -> None:

        if not build_type.lower() in self.all_build_types:
            raise Exception(f"Unsupported CMAKE_BUILD_TYPE '{build_type}'")
        if not conan_profile.lower() in self.all_profiles:
            raise Exception(f"Unsupported Conan profile '{conan_profile}'")

        cmd_args = [
            f"--settings build_type={build_type}",
            f"--conf tools.cmake.cmaketoolchain:generator={self.generator}",
            f"--build=missing",
            f"--profile:all={conan_profile}"
        ]
        cmd_line = f"conan install . " + f' '.join(cmd_args)

        try:
            print(f"call `" + ' '.join([*self.shell, cmd_line]) + "`")
            subprocess.run([*self.shell, cmd_line], check=True)
        except FileNotFoundError as e:
            print(f"Process failed because the executable could not be found.\n{e}")
        except subprocess.CalledProcessError as e:
            print(
                f"Process failed because did not return a successful return code. "
                f"Returned {e.returncode}\n{e}"
            )

    @dispatch(list, str)
    def install(self, build_types: list, conan_profile: str) -> None:
        for build_type in build_types:
            self.install(build_type, conan_profile)

    @dispatch(list)
    def install(self, build_types: list) -> None:
        self.install(build_types, self.conan_profile)

if __name__ == '__main__':
    conan = ConanInstaller()
    conan.removeConanPresetsJson('CMakeConanPresets.json')
    conan.install(['Debug', 'Release'])
