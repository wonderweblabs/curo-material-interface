'use strict'

# Polymer
Polymer

  is: 'cmi-checkbox'

  properties:
    checked: { type: Boolean, value: false, reflectToAttribute: true, notify: true, observer: '_checkedChanged' }
    toggles: { type: Boolean, value: true, reflectToAttribute: true }

  behaviors: [
    Polymer.PaperInkyFocusBehavior
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

    @_isReady = true

  _buttonStateChanged: ->
    return if @disabled

    @checked = @active if @_isReady

  _checkedChanged: (checked) ->
    @setAttribute('aria-checked', if checked then 'true' else 'false')
    @active = @checked
    @fire 'iron-change'

  _computeCheckboxClass: (checked) ->
    if (checked) then 'checked' else ''

  _computeCheckmarkClass: (checked) ->
    if !checked then 'hidden' else ''

