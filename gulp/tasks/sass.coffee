module.exports = (gulp, config) ->
  path          = require('path')
  sass          = require('gulp-sass')
  util          = require('gulp-util')
  sourcemaps    = require('gulp-sourcemaps')
  changed       = require('gulp-changed')

  appendError   = require('../helper/stream_error_appender')
  appendNotify  = require('../helper/stream_notify_appender')

  componentsPath = path.join(config.cmiRoot, 'src/webcomponents')

  # ----------------------------------------------------------------------------------------
  gulp.task 'cmi-compile-sass', ->
    stream = gulp.src(["#{componentsPath}/**/*.sass"])
    stream = stream.pipe(changed(config.destPath, { extension: '.css' }))
    stream = appendError(stream, config, 'CMI Sass Error')
    stream = stream.pipe(sourcemaps.init())                   if config.env == 'development'
    stream = stream.pipe(sass({
      indentedSyntax:   true
      errLogToConsole:  true
      includePaths:     config.sassPath
    }).on('error', util.log))
    stream = stream.pipe(sourcemaps.write())                  if config.env == 'development'
    stream = stream.pipe(gulp.dest(config.destPath))
    stream = appendNotify(stream, config, 'CMI Sass', 'Done compiling')