'use strict'

# Polymer
Polymer

  is: 'cmi-checkbox'

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

    @_isReady = true

  _buttonStateChanged: ->
    return if @disabled

    @checked = @active if @_isReady

  _checkedChanged: ->
    Polymer.IronCheckedElementBehaviorImpl._checkedChanged.apply(@)

    @setAttribute('aria-checked', if @checked then 'true' else 'false')

  _computeCheckboxClass: (checked) ->
    if (checked) then 'checked' else ''

  _computeCheckmarkClass: (checked) ->
    if !checked then 'hidden' else ''

