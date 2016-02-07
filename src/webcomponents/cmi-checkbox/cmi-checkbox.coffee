'use strict'

Polymer

  is: 'cmi-checkbox'

  properties:
    ###
    Fired when the checked state changes due to user interaction.

    @event change
    ###

    ###
    Fired when the checked state changes.

    @event iron-change
    ###

    ###*
    * SASS-Variables
    *
    * |   |   |   |
    * |---|---|---|
    * |$cmi-checkbox-ink-color              | | Ripple color |
    * |$cmi-checkbox-border-color           | | Border color - default |
    * |$cmi-checkbox-border-color-checked   | | Border color - checked |
    * |$cmi-checkbox-border-color-invalid   | | Border color - invalid |
    * |$cmi-checkbox-border-color-disabled  | | Border color - disabled |
    * |$cmi-checkbox-bg-checked             | | Background color - checked |
    * |$cmi-checkbox-bg-invalid             | | Background color - invalid |
    * |$cmi-checkbox-bg-disabled-checked    | | Background color - disabled |
    * |$cmi-checkbox-checkmark-color        | | Color checkmark |
    * |$cmi-checkbox-label-color            | | Label color - default |
    * |$cmi-checkbox-label-color-invalid    | | Label color - invalid |
    * |$cmi-checkbox-label-color-disabled   | | Label color - disabled |
    *
    ###
    aaaSass: {}

    ariaActiveAttribute: { type: String, value: 'aria-checked' }

  behaviors: [
    Polymer.PaperCheckedElementBehavior
  ]

  hostAttributes:
    role: 'checkbox'
    'aria-checked': false
    tabindex: 0

  _computeCheckboxClass: (checked, invalid) ->
    className = ''
    className += 'checked ' if checked
    className += 'invalid' if invalid
    className

  _computeCheckmarkClass: (checked) ->
    if checked then '' else 'hidden'

  # create ripple inside the checkboxContainer
  _createRipple: ->
    @_rippleContainer = @.$.checkboxContainer

    Polymer.PaperInkyFocusBehaviorImpl._createRipple.call(@)

