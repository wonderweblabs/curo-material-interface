$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "curo_material_interface/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "curo-material-interface"
  s.version     = CuroMaterialInterface::VERSION
  s.authors     = ["Sascha Hillig", "Alexander Schrot", "wonderweblabs"]
  s.email       = ["email@wonderweblabs.com"]
  s.homepage    = "https://github.com/wonderweblabs/curo-material-interface"
  s.summary     = "Frontend framework to provide google material ui like interfaces. Extracted from curo cms."
  s.description = "Frontend framework to provide google material ui like interfaces. Extracted from curo cms."
  s.license     = "MIT"

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    ".gitignore",
    "LICENSE",
    "Rakefile",
    "README.md"
  ]
  s.require_path = 'lib'

  s.add_runtime_dependency('sass', '~> 3.4')
  s.add_runtime_dependency('coffee-script', '~> 2.4')

end