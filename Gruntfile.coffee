module.exports = (grunt) ->

  # Time how long tasks take. Can help when optimizing build times
  # require('time-grunt')(grunt)

  # graspi configuration
  File   = require('path')
  dir    = File.resolve()
  graspi = require('graspi')(grunt,
    gruntRoot:            dir
    configTmpFile:        File.join(dir, 'graspi/tmp/config.yml')
    configLoadPaths:      [
      File.join(dir, 'graspi/config_libs'),
      File.join(dir, 'graspi/config_polymer'),
      File.join(dir, 'graspi/config_graspi'),
      File.join(dir, 'graspi/config_develop')
    ]
    tasksLoadPaths:       []
  )

  # Automatically load required grunt tasks
  require('jit-grunt')(grunt)

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