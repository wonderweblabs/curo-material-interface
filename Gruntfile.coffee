module.exports = (grunt) ->

  _       = require('lodash')
  File    = require('path')
  basedir = File.resolve()

  # Time how long tasks take. Can help when optimizing build times
  # require('time-grunt')(grunt)

  # Automatically load required grunt tasks
  require('jit-grunt')(grunt)

  # graspi configuration
  grunt.option('root', basedir)
  grunt.option('configCache', File.join(basedir, 'tmp/graspi/config.yml'))
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
    concurrent:
      options:
        logConcurrentOutput: true
      build_cmi_pages:
        tasks: [
          'watch_cmi_pages_assets',
          'watch_cmi_pages',
          'watch_cmi'
        ]
    watch:
      build_cmi:
        tasks: [
          'build_cmi',
          'build_cmi_pages_cmi'
        ]
        files: [
          'lib/assets/cmi/**/*',
          'src/webcomponents/**/*'
        ]
      build_cmi_pages:
        options:
          livereload: true
        tasks: [
          'build_cmi_pages'
        ]
        files: [
          'src/**/*.haml',
          'src/**/*.context.yml',
          '!src/webcomponents/**/*'
        ]
      build_cmi_pages_assets:
        tasks: [
          'build_cmi_pages_assets',
          'build_cmi_pages_cmi_pages_assets'
        ]
        files: [
          'src/javascripts/**/*',
          'src/stylesheets/**/*',
          'src/images/**/*'
        ]
    browserSync:
      build_cmi_pages:
        options:
          server: baseDir: "./build"
          watchTask: true
          open: false
          injectChanges: false
          reloadDelay: 0
          reloadDebounce: 500
        bsFiles:
          src: [ 'tmp/browserSyncReloader.txt' ]

  # use this one
  grunt.registerTask 'cmi_dev', [
    'concurrent:build_cmi_pages'
  ]

  # tasks to run the watcher
  grunt.registerTask 'watch_cmi', [
    'watch:build_cmi'
  ]
  grunt.registerTask 'watch_cmi_pages_assets', [
    'watch:build_cmi_pages_assets'
  ]
  grunt.registerTask 'watch_cmi_pages', [
    'browserSync:build_cmi_pages',
    'watch:build_cmi_pages'
  ]

  # tasks to switch graspi mod_name
  grunt.registerTask 'build_cmi', ->
    grunt.option 'mod_name', 'cmi'
    grunt.task.run 'graspi'

  grunt.registerTask 'build_cmi_pages_assets', ->
    grunt.option 'mod_name', 'cmi-pages'
    grunt.task.run 'graspi'



  # ----------------------------------------------------------------
  # options
  root = File.resolve()
  expandOptions = { cwd: File.join(root, 'src') }
  pageDefaults  =
    pageTitle: 'CMI'
    layout: 'default'

  # ----------------------------------------------------------------
  # main task
  grunt.registerTask 'build_cmi_pages', ->
    grunt.task.run 'build_cmi_pages_sidebars'
    grunt.task.run 'build_cmi_pages_content_sass'
    grunt.task.run 'build_cmi_pages_content_replace'
    grunt.task.run 'build_cmi_pages_content_touch'

  grunt.registerTask 'build_cmi_pages_cmi', ->
    env = grunt.option('env_name') || 'development'
    @requires("graspi_build_after:#{env}:cmi:build")
    grunt.task.run 'build_cmi_pages'

  grunt.registerTask 'build_cmi_pages_cmi_pages_assets', ->
    env = grunt.option('env_name') || 'development'
    @requires("graspi_build_after:#{env}:cmi-pages:build")
    grunt.task.run 'build_cmi_pages'

  # ----------------------------------------------------------------
  # sidebars
  grunt.registerTask 'build_cmi_pages_sidebars', ->
    configs = grunt.file.expand(expandOptions, [
      '**/*.context.yml'
    ])
    files = grunt.file.expand(expandOptions, [
      '**/*_sidebar.haml'
    ])

    _.each files, (file) =>
      id = _.uniqueId('cmi-')

      contextFile = file.replace(/\_sidebar\.haml$/, '.context.yml')

      cfg = {}
      if _.includes configs, contextFile
        cfg = grunt.file.readYAML(File.join(root, 'src', contextFile))
      cfg = _.merge pageDefaults, cfg

      gruntCfg              = {}
      gruntCfg[id]          = {}
      gruntCfg[id].files    = []
      gruntCfg[id].options  = {}
      gruntCfg[id].options  = {}
      gruntCfg[id].options.language       = 'coffee'
      gruntCfg[id].options.target         = 'html'
      gruntCfg[id].options.placement      = 'global'
      gruntCfg[id].options.context        = cfg
      gruntCfg[id].files.push
        src:  File.join(root, 'src', file)
        dest: File.join(root, 'tmp/html', "#{File.basename(file, File.extname(file))}.html")
      grunt.config.merge { haml: gruntCfg }
      grunt.task.run "haml:#{id}"

  # ----------------------------------------------------------------
  # content sass
  grunt.registerTask 'build_cmi_pages_content_sass', ->
    files         = grunt.file.expand(expandOptions, [
      '**/*.haml',
      '!**/_*.haml',
      '!**/*_sidebar.haml',
      '!layouts/**/*'
    ])
    configs = grunt.file.expand(expandOptions, [
      '**/*.context.yml'
    ])

    manifest  = grunt.file.readJSON('tmp/graspi/g-assets.json')
    env       = grunt.option('env_name') || 'development'
    buildPath = if env == 'development' then File.join(root, 'build') else root
    manifest  = manifest[env]

    _.each files, (file) =>
      id = _.uniqueId('cmi-')

      cfg = {}
      if _.includes configs, "#{File.basename(file, File.extname(file))}.context.yml"
        cfg = grunt.file.readYAML(File.join(root, 'src', "#{File.basename(file, File.extname(file))}.context.yml"))
      cfg = _.merge pageDefaults, cfg

      # compile hamls
      gruntCfg              = {}
      gruntCfg[id]          = {}
      gruntCfg[id].files    = []
      gruntCfg[id].options  = {}
      gruntCfg[id].options  = {}
      gruntCfg[id].options.language       = 'coffee'
      gruntCfg[id].options.target         = 'html'
      gruntCfg[id].options.placement      = 'global'
      gruntCfg[id].options.context        = cfg
      gruntCfg[id].files.push
        src:  File.join(root, 'src', 'layouts', "#{cfg.layout}.haml")
        dest: File.join(root, 'tmp/html', "#{File.basename(file, File.extname(file))}.html")
      gruntCfg[id].files.push
        src:  File.join(root, 'src', file)
        dest: File.join(root, 'tmp/html', "#{File.basename(file, File.extname(file))}_content.html")
      grunt.config.merge { haml: gruntCfg }
      grunt.task.run "haml:#{id}"

  # ----------------------------------------------------------------
  # content replace
  grunt.registerTask 'build_cmi_pages_content_replace', ->
    files         = grunt.file.expand(expandOptions, [
      '**/*.haml',
      '!**/_*.haml',
      '!**/*_sidebar.haml',
      '!layouts/**/*',
      '!webcomponents/**/*'
    ])
    configs = grunt.file.expand(expandOptions, [
      '**/*.context.yml'
    ])

    manifest  = grunt.file.readJSON('tmp/graspi/g-assets.json')
    env       = grunt.option('env_name') || 'development'
    buildPath = if env == 'development' then File.join(root, 'build') else root
    manifest  = manifest[env]

    pathsCss  = []
    pathsJs   = []
    pathsWC   = []
    pathsTpl  = []
    pathsCss.push manifest['cmi/cmi.css']
    pathsCss.push manifest['cmi-pages/application.css']
    pathsJs.push manifest['cmi/cmi.js']
    pathsJs.push manifest['cmi-pages/application.js']
    pathsWC.push manifest['cmi/webcomponents.html']
    pathsTpl.push manifest['cmi/templates.html']

    _.each files, (file) =>
      id = _.uniqueId('cmi-')

      cfg = {}
      if _.includes configs, "#{File.basename(file, File.extname(file))}.context.yml"
        cfg = grunt.file.readYAML(File.join(root, 'src', "#{File.basename(file, File.extname(file))}.context.yml"))
      cfg = _.merge pageDefaults, cfg

      # read content
      content = grunt.file.read(File.join('tmp/html', "#{File.basename(file, File.extname(file))}_content.html"))
      sidebarContent = ''
      if grunt.file.exists(File.join('tmp/html', "#{File.basename(file, File.extname(file))}_sidebar.html"))
        sidebarContent = grunt.file.read(File.join('tmp/html', "#{File.basename(file, File.extname(file))}_sidebar.html"))

      # concat to result file
      gruntCfg              = {}
      gruntCfg[id]          = {}
      gruntCfg[id].files    = [{
        src:  File.join(root, 'tmp/html', "#{File.basename(file, File.extname(file))}.html")
        dest: File.join(buildPath, "#{File.basename(file, File.extname(file))}.html")
      }]
      gruntCfg[id].options  = {}
      gruntCfg[id].options.patterns = []
      gruntCfg[id].options.patterns.push
        match: 'yield_content'
        replace: content
      gruntCfg[id].options.patterns.push
        match: 'yield_sidebar_content'
        replace: sidebarContent

      yield_style = []
      _.each (pathsCss || []), (file) =>
        return unless _.isString(file)
        if file == 'assets/cmi_pages/application.css'
          yield_style.push "<link rel='stylesheet' media='screen' href='#{file}' is='custom-style' />"
        else
          yield_style.push "<link rel='stylesheet' media='screen' href='#{file}' />"
      gruntCfg[id].options.patterns.push
        match: 'yield_style'
        replace: yield_style.join('\n')

      yield_script = []
      _.each (pathsJs || []), (file) =>
        return unless _.isString(file)
        yield_script.push "<script src='#{file}'></script>"
      gruntCfg[id].options.patterns.push
        match: 'yield_script'
        replace: yield_script.join('\n')

      yield_tpl = []
      _.each (pathsTpl || []), (file) =>
        return unless _.isString(file)
        return unless grunt.file.exists(file)
        yield_tpl.push grunt.file.read(file)
      gruntCfg[id].options.patterns.push
        match: 'yield_tpl'
        replace: yield_tpl.join('\n')

      yield_webcomponents = []
      _.each (pathsWC || []), (file) =>
        return unless _.isString(file)
        yield_webcomponents.push "<link rel='import' href='#{file}' />"
      gruntCfg[id].options.patterns.push
        match: 'yield_webcomponents'
        replace: yield_webcomponents.join('\n')

      grunt.config.merge { replace: gruntCfg }
      grunt.task.run "replace:#{id}"

  # ----------------------------------------------------------------
  # content replace
  grunt.registerTask 'build_cmi_pages_content_touch', ->
    gruntCfg                            = {}
    gruntCfg['cmi_pages']               = {}
    gruntCfg['cmi_pages'].options       = {}
    gruntCfg['cmi_pages'].options.force = true
    gruntCfg['cmi_pages'].src           = [ 'tmp/browserSyncReloader.txt' ]

    grunt.log.error 'touch!!'
    grunt.config.merge { touch: gruntCfg }
    grunt.task.run "touch:cmi_pages"


  null