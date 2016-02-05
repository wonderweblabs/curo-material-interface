'use strict'

###
  Polymer.CmiButtonBehavior` implements general features for cmi button
  elements like cmi-button or cmi-fab.

  @polymerBehavior Polymer.CmiButtonBehavior
###
Polymer.CmiButtonBehaviorImpl =

  properties:

    filled:   { type: Boolean, reflectToAttribute: true, value: false }
    small:    { type: Boolean, reflectToAttribute: true, value: false }
    large:    { type: Boolean, reflectToAttribute: true, value: false }
    theme:    { type: String, reflectToAttribute: true, value: 'default' }

    ###
    If true, the button will behave as block element
    ###
    block: { type: Boolean, reflectToAttribute: true, value: false }

    ###
    If true, the button should be styled with a shadow.
    ###
    raised:
      type: Boolean
      reflectToAttribute: true
      value: false
      observer: '_calculateElevation'

  _calculateElevation: ->
    if !@raised
      @_setElevation(0)
    else
      Polymer.PaperButtonBehaviorImpl._calculateElevation.apply(@)

  _computeContentClass: (receivedFocusFromKeyboard) ->
    classes = []

    classes.push 'content'
    classes.push 'cmi-button'
    classes.push 'keyboard-focus' if receivedFocusFromKeyboard

    classes.join(' ')


    ###
    Fired when the animation finishes.
    This is useful if you want to wait until
    the ripple animation finishes to perform some action.

    @event transitionend
    @param {{node: Object}} detail Contains the animated node.
    ###

###
  @polymerBehavior Polymer.CmiButtonBehavior
###
Polymer.CmiButtonBehavior = [
  Polymer.PaperButtonBehavior,
  Polymer.CmiButtonBehaviorImpl
]