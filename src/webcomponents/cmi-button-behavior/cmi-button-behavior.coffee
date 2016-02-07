'use strict'

###
  Polymer.CmiButtonBehavior` implements general features for cmi button
  elements like cmi-button or cmi-fab.

  @polymerBehavior Polymer.CmiButtonBehavior
###
Polymer.CmiButtonBehaviorImpl =

  properties:

    ###*
    * SASS-Variables
    *
    * |   |   |   |
    * |---|---|---|
    * |$cmi-button-paper-ripple-color     | | Ripple color value |
    * |$cmi-button-bg-filled              | | background-color - filled |
    * |$cmi-button-bg-primary             | | background-color - filled primary |
    * |$cmi-button-bg-highlight           | | background-color - filled highlight |
    * |$cmi-button-bg-danger              | | background-color - filled danger |
    * |$cmi-button-bg-disabled            | | background-color - filled disabled |
    * |$cmi-button-color-filled-primary   | | text color - filled primary |
    * |$cmi-button-color-filled-highlight | | text color - filled highlight |
    * |$cmi-button-color-filled-danger    | | text color - filled danger |
    * |$cmi-button-color-disabled         | | text color - disabled |
    *
    ###
    aaaSass: {}

    ###*
    * If true, the button will have a color as background.
    ###
    filled:   { type: Boolean, reflectToAttribute: true, value: false }

    ###*
    * If true, the font-size and padding of the button will be smaller.
    ###
    small:    { type: Boolean, reflectToAttribute: true, value: false }

    ###*
    * If true, the font-size and padding of the button will be larger.
    ###
    large:    { type: Boolean, reflectToAttribute: true, value: false }

    ###*
    * Color theme of the button. Options:
    *
    * * primary
    * * highlight
    * * danger
    *
    * The actual colors depend on the sass variables set (see aaaSass).
    ###
    theme:    { type: String, reflectToAttribute: true, value: 'default' }

    ###*
    * If true, the button will behave as block element
    ###
    block: { type: Boolean, reflectToAttribute: true, value: false }

    ###*
    * If true, the button should be styled with a shadow.
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

  ###*
  * Fired when the animation finishes.
  * This is useful if you want to wait until
  * the ripple animation finishes to perform some action.
  *
  * @event transitionend
  * @param {{node: Object}} detail Contains the animated node.
  ###

###
  @polymerBehavior
###
Polymer.CmiButtonBehavior = [
  Polymer.PaperButtonBehavior,
  Polymer.CmiButtonBehaviorImpl
]