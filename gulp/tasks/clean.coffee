module.exports = (gulp, config) ->
  runSequence = require('run-sequence').use(gulp)
  rimraf      = require('gulp-rimraf')

  gulp.task 'cmi-clean', ->
    # return gulp.src([
    #   'www/*',
    #   'src/config/config.coffee'
    # ], { read: false })
    # .pipe(rimraf())
