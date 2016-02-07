module.exports = (gulp, config) ->
  path          = require('path')
  rename        = require('gulp-rename')
  changed       = require('gulp-changed')

  appendError   = require('../helper/stream_error_appender')
  appendNotify  = require('../helper/stream_notify_appender')

  componentsPath = path.join(config.cmiRoot, 'src/webcomponents')

  # ----------------------------------------------------------------------------------------
  gulp.task 'cmi-copy', ->
    gulp.start 'cmi-copy-bower'

  # ----------------------------------------------------------------------------------------
  gulp.task 'cmi-copy-bower', ->
    stream = gulp.src(["#{componentsPath}/**/bower.json"])
    stream = stream.pipe(changed(config.destPath))
    stream = appendError(stream, config, 'CMI Copy Error')
    stream = stream.pipe(gulp.dest(config.destPath))

    stream = gulp.src(["#{componentsPath}/**/bower.json"])
    stream = stream.pipe(changed(config.destPath))
    stream = appendError(stream, config, 'CMI Copy Error')
    stream = stream.pipe(rename((path) -> path.basename = '.bower'))
    stream = stream.pipe(gulp.dest(config.destPath))
    stream = appendNotify(stream, config, 'CMI Copy', 'Done compiling')
    stream