'use strict'

Polymer

  is: 'cmi-checkbox'

  properties:
    # value:
    #   type: String
    #   reflectToAttribute: true
    #   value: ''
    # boolean:
    #   type: Boolean
    #   reflectToAttribute: true
    #   value: false
    #   notify: true
    #   observer: '_booleanChanged'
    # checkedValue:
    #   type: String
    #   value: 'true'
    # uncheckedValue:
    #   type: String
    #   value: null

    ###
    Fired when the checked state changes due to user interaction.

    @event change
    ###

    ###
    Fired when the checked state changes.

    @event iron-change
    ###
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

