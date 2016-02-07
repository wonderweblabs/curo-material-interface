module.exports = (gulp, config) ->
  path = require('path')

  # init config
  config          or= {}
  config.env      or= 'development'
  config.notify   or= false
  config.notify   = if config.notify == true || config.notify == 'true' then true else false
  config.sassPath or= []
  config.cmiRoot  = path.join(__dirname, '..')

  # require tasks
  require('./tasks/build')(gulp, config)
  require('./tasks/clean')(gulp, config)
  require('./tasks/coffee')(gulp, config)
  require('./tasks/copy')(gulp, config)
  require('./tasks/hamlc')(gulp, config)
  require('./tasks/sass')(gulp, config)
  require('./tasks/watch')(gulp, config)
