# [Recipe tools](https://docs.conan.io/2/reference/tools.html)
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps, cmake_layout
from conan.tools.files import load, save
import json
import os

class ActionTestRecipe(ConanFile):
    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"

    def requirements(self):
        self.requires("catch2/3.7.1")

    def layout(self):
        # see: conan.io #17324
        #self.folders.build_folder_vars = ["settings.compiler", "settings.build_type"]
        cmake_layout(self)

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        tc = CMakeToolchain(self)
        tc.user_presets_path = "ConanCMakePresets.json"
        tc.generate()
        # remove buildPresets/jobs since we'll use own calculation, see: conan-io #16036
        conan_jobs = False
        if(not conan_jobs):
            presets = json.loads(load(self, "CMakePresets.json"))
            for element in presets['buildPresets']:
                if element.get("jobs") is not None:
                    del element["jobs"]
            save(self, "CMakePresets.json", json.dumps(presets, indent=4))
