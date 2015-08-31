'use strict'

Polymer

  is: 'cmi-checkbox'

  properties:
    value:
      type: String
      reflectToAttribute: true
      value: ''
    boolean:
      type: Boolean
      reflectToAttribute: true
      value: false
      notify: true
      observer: '_booleanChanged'
    checkedValue:
      type: String
      value: 'true'
    uncheckedValue:
      type: String
      value: null

  behaviors: [
    Polymer.PaperInkyFocusBehavior,
    Polymer.IronCheckedElementBehavior
  ]

  hostAttributes:
    role: 'checkbox'
    'aria-checked': false
    tabindex: 0

  ready: ->
    if Polymer.dom(@).textContent == ''
      @.$.checkboxLabel.hidden = true
    else
      @setAttribute('aria-label', Polymer.dom(@).textContent)

    @async =>
      @_originalCheckedValue = @value || @checkedValue
      @_originalUncheckedValue = @uncheckedValue
      @_originalValue = @value
      @_booleanChanged()

    @_isReady = true

  _booleanChanged: ->
    if @boolean
      @checkedValue = 'true'
      @uncheckedValue = 'false'
    else
      @checkedValue = @value || @_originalCheckedValue
      @uncheckedValue = @_originalUncheckedValue

    @_checkedChanged()

  _checkedChanged: ->
    @active = @checked

    @value = if @checked then @checkedValue else @uncheckedValue

    @setAttribute('aria-checked', if @checked then 'true' else 'false')

    @fire('iron-change')

  _buttonStateChanged: ->
    return if @disabled

    @checked = @active if @_isReady

  _computeCheckboxClass: (checked) ->
    if (checked) then 'checked' else ''

  _computeCheckmarkClass: (checked) ->
    if !checked then 'hidden' else ''

