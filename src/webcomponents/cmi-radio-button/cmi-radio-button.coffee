'use strict'

# Polymer
Polymer

  is: 'cmi-radio-button'

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

  attached: ->
    trimmedText = Polymer.dom(@).textContent.trim()

    @.$.radioLabel.hidden = true if trimmedText == ''

    if trimmedText != '' && !@getAttribute('aria-label')
      @setAttribute('aria-label', trimmedText)

    @_isReady = true

  _buttonStateChanged: ->
    return if @disabled

    @checked = @active if @_isReady

  _checkedChanged: ->
    @setAttribute('aria-checked', if @checked then 'true' else 'false')
    @active = @checked
    @fire 'iron-change'

