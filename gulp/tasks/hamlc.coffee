module.exports = (gulp, config) ->
  path          = require('path')
  hamlc         = require('gulp-haml-coffee')
  gulpReplace   = require('gulp-replace')

  appendError   = require('../helper/stream_error_appender')
  appendNotify  = require('../helper/stream_notify_appender')

  componentsPath = path.join(config.cmiRoot, 'src/webcomponents')


  # ----------------------------------------------------------------------------------------
  #
  # Haml-coffee-hack:
  # There is the problem, that polymer expects sometimes an html attribute
  # to be like class$="something". But haml-coffee interpret and execute this
  # which will result in an exception. That's why we replace those parts with
  # "DOLLAREQUALSIGNS=" and back afterwards. Script is still running fast.
  #
  gulp.task 'cmi-compile-hamlc', ->
    stream = gulp.src(["#{componentsPath}/**/*.hamlc"])
    stream = appendError(stream, config, 'CMI Haml-Coffee Error')
    stream = stream.pipe(gulpReplace(/\$\=/g, 'DOLLAREQUALSIGNS='))
    stream = stream.pipe(hamlc({ js: false }))
    stream = stream.pipe(gulpReplace(/DOLLAREQUALSIGNS\=/g, '$='))
    stream = stream.pipe(gulp.dest(config.destPath))
    stream = appendNotify(stream, config, 'CMI Haml-Coffee', 'Done compiling')
    stream