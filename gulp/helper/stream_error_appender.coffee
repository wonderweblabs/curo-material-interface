module.exports = (stream, config, title) ->
  util = require('gulp-util')

  return stream.on 'error', (error) ->
    util.log("#{title} - #{error.toString()}")

    if config.notify == true
      notify.onError({
        title:    title
        message:  error.toString()
      })(error)

    stream.EventEmitter.emit('end')