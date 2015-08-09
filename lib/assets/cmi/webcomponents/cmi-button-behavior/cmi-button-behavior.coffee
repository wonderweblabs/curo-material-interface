'use strict'

#
Polymer.CmiButtonBehaviorImpl =

  properties:

    filled:   { type: Boolean, reflectToAttribute: true, value: false }
    small:    { type: Boolean, reflectToAttribute: true, value: false }
    large:    { type: Boolean, reflectToAttribute: true, value: false }
    block:    { type: Boolean, reflectToAttribute: true, value: false }
    theme:    { type: String, reflectToAttribute: true, value: 'default' }

    href:     { type: String, reflectToAttribute: true, value: null }
    target:   { type: String, reflectToAttribute: true, value: '_self' }
    title:    { type: String, reflectToAttribute: true, value: null }

    #
    # Raised - shadow style
    #
    raised:
      type: Boolean
      reflectToAttribute: true
      value: false
      observer: '_calculateElevation'

  _upHandler: ->
    @_openLink()
    Polymer.IronButtonStateImpl._upHandler.apply(@)

  _asyncClick: ->
    @_openLink()
    Polymer.IronButtonStateImpl._asyncClick.apply(@)

  _openLink: ->
    return unless @href != null && @href != undefined

    target = @target
    target or= '_self'

    @_setFocused(false)
    @_setPointerDown(false)
    @_setPressed(false)
    window.open(@href, target)

  _calculateElevation: ->
    if @raised
      Polymer.PaperButtonBehaviorImpl._calculateElevation.apply(@)
    else if @active || @pressed
      @_elevation = 1
    else
      @_elevation = 0

  _computeContentClass: (receivedFocusFromKeyboard) ->
    classes = []

    classes.push 'content'
    classes.push 'cmi-button'
    classes.push 'keyboard-focus' if receivedFocusFromKeyboard

    classes.join(' ')



# Polymer
Polymer.CmiButtonBehavior = [
  Polymer.PaperButtonBehavior,
  Polymer.CmiButtonBehaviorImpl
]

# Polymer
Polymer

  is: 'cmi-button-behavior'

