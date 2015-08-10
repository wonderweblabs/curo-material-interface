module.exports = (grunt) ->

  File    = require('path')
  basedir = File.resolve()

  # Time how long tasks take. Can help when optimizing build times
  # require('time-grunt')(grunt)

  # Automatically load required grunt tasks
  require('jit-grunt')(grunt)

  # graspi configuration
  grunt.option('root', basedir)
  grunt.option('configCache', File.join(basedir, 'graspi/tmp/config.yml'))
  grunt.option('configLoadPaths', [
    File.join(basedir, 'graspi/config_libs'),
    File.join(basedir, 'graspi/config_polymer'),
    File.join(basedir, 'graspi/config_graspi'),
    File.join(basedir, 'graspi/config_develop')
  ])
  require('graspi')(grunt)

  # ----------------------------------------------------------------
  # tasks
  # ----------------------------------------------------------------

  grunt.registerTask('default', ['graspi'])

  # ----------------------------------------------------------------
  # Grunt config
  # ----------------------------------------------------------------
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  null