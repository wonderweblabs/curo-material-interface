module.exports = (gulp, config) ->
  runSequence = require('run-sequence').use(gulp)

  gulp.task 'cmi-build', ['cmi-clean'], (cb) ->
    runSequence(
      'cmi-copy',
      'cmi-compile-hamlc',
      'cmi-compile-coffee',
      'cmi-compile-sass',
      cb
    )
