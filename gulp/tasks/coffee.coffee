module.exports = (gulp, config) ->
  path          = require('path')
  coffee        = require('gulp-coffee')
  util          = require('gulp-util')
  sourcemaps    = require('gulp-sourcemaps')
  changed       = require('gulp-changed')

  appendError   = require('../helper/stream_error_appender')
  appendNotify  = require('../helper/stream_notify_appender')

  componentsPath = path.join(config.cmiRoot, 'src/webcomponents')

  # ----------------------------------------------------------------------------------------
  gulp.task 'cmi-compile-coffee', ->
    stream = gulp.src(["#{componentsPath}/**/*.coffee"])
    stream = stream.pipe(changed(config.destPath, { extension: '.js' }))
    stream = appendError(stream, config, 'CMI Coffee Error')
    stream = stream.pipe(sourcemaps.init())                   if config.env == 'development'
    stream = stream.pipe(coffee({ bare: true }).on('error', util.log))
    stream = stream.pipe(sourcemaps.write())                  if config.env == 'development'
    stream = stream.pipe(gulp.dest(config.destPath))
    stream = appendNotify(stream, config, 'CMI Coffee', 'Done compiling')
    stream
