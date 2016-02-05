gulp  = require('gulp')
cmi   = require('./gulp/tasks')(gulp, {
  notify:   gulp.env.notify || false
  destPath: 'build/bower_components'
  sassPath: [
    'build/bower_components',
    'build/bower_components/bourbon/app/assets/stylesheets',
    'build/bower_components/neat/app/assets/stylesheets',
    'src/var',
    'src/stylesheets/webcomponents'
  ]
})