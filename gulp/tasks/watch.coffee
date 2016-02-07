module.exports = (gulp, config) ->
  path = require('path')

  componentsPath = path.join(config.cmiRoot, 'src/webcomponents')

  gulp.task 'cmi-watch', ->
    gulp.watch ["#{componentsPath}/**/*.coffee"], ['cmi-compile-coffee']
    gulp.watch ["#{componentsPath}/**/*.sass"], ['cmi-compile-sass']
    gulp.watch ["#{componentsPath}/**/*.hamlc"], ['cmi-compile-hamlc']
    gulp.watch ["#{componentsPath}/bower.json"], ['cmi-copy-bower']