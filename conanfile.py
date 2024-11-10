from conan import ConanFile
from conan.tools.cmake import cmake_layout
from conan.tools.cmake import CMakeToolchain

class CompressorRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps" , "CMakeToolchain"

    def requirements(self):
        self.requires("catch2/3.7.1")

    def layout(self):
        cmake_layout(self)

#    def generate(self):
#        tc = CMakeToolchain(self)
#        tc.user_presets_path = 'CMakeConanPresets.json'
#        tc.generate()
