window.CMI or= {}

class CMI.LoadingIndicator extends Backbone.View

  className: 'cmi-loading-indicator'

  initialize: (options = {}) ->
    @_options = _.extend(@_defaultOptions(), options)
    @render()

  render: ->
    @.$el.html(@_getInnerHtml())

    if @_options.background == 'dark'
      @.$el.addClass('cmi-loading-indicator-background-dark')
    else if @_options.background == 'light'
      @.$el.addClass('cmi-loading-indicator-background-light')
    else if @_options.background? == true && @_options.background.length > 0
      @.$el.addClass(@_options.background)

    @

  domElement: ->
    @.$el

  fadeIn: ->
    @_attach() if @_isAttached() == false
    @.$el.addClass('cmi-loading-fade')
    @

  fadeOut: ->
    @.$el.removeClass('cmi-loading-fade')
    _.delay($.proxy(@, '_detach'), 300) if @_options.detachAfterFadeOut
    @



  # ---------------------------------------------
  # private methods

  _getInnerHtml: ->
    $('<div class="cmi-loading-indicator-inside">
        <svg class="circular">
          <circle class="path" cx="50" cy="50" fill="none" r="20" stroke-miterlimit="10" stroke-width="3"></circle>
        </svg>
      </div>')

  _detach: ->
    @.$el.detach()
    @_attached = false

  _attach: ->
    return if @_options.parent? == false
    @_options.parent.append(@.$el)
    @_attached = true

  _isAttached: ->
    @_attached or= false

  _defaultOptions: ->
    {
      background: null
      parent: null
      detachAfterFadeOut: true
    }


