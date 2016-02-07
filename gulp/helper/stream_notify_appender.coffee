module.exports = (stream, config, title, message) ->
  return stream unless config.notify == true

  return stream.pipe((require('gulp-notify'))({
    title:    title
    message:  message
  }))