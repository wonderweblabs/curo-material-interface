'use strict'

# Polymer
Polymer

  is: 'cmi-dropdown-menu'

  behaviors: [
    Polymer.IronControlState,
    Polymer.IronButtonState
  ]

  properties:
    selectedItemLabel:
      type: String
      notify: true
      computed: '_computeSelectedItemLabel(selectedItem)'
    selectedItem:
      type: Object
      notify: true
      readOnly: true
    label:
      type: String
    placeholder:
      type: String
    opened:
      type: Boolean
      notify: true
      value: false
    noLabelFloat:
      type: Boolean
      value: false
      reflectToAttribute: true
    alwaysFloatLabel:
      type: Boolean
      value: false
    noAnimations:
      type: Boolean
      value: false

  listeners:
    'tap': '_onTap'

  keyBindings:
    'up down': 'open'
    'esc': 'close'

  hostAttributes:
    role: 'group'
    'aria-haspopup': 'true'

  open: ->
    @.$.menuButton.open()
    console.log 'OPEN'
    @fire 'paper-dropdown-open'

  close: ->
    @.$.menuButton.close()
    console.log 'CLOSE'
    @fire 'paper-dropdown-close'

  _onIronActivate: (event) ->
    @_setSelectedItem(event.detail.item)

  _onTap: (event) ->
    @open() if (Polymer.Gestures.findOriginalTarget(event) == @)


  _computeSelectedItemLabel: (selectedItem) ->
    return '' if !selectedItem

    selectedItem.label || selectedItem.textContent.trim()

  _computeMenuVerticalOffset: (noLabelFloat) ->
    if noLabelFloat then -4 else 16



