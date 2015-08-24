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
      observer: '_selectedItemChange'
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

  close: ->
    @.$.menuButton.close()

  _selectedItemChange: ->
    @fire 'cmi-dropdown-menu-select'

  _nameChanged: ->
    if @name == null || @name == undefined || @name == '' || @name == ' '
      @_formElementUnregister()
    else
      @_formElementRegister()

  _onIronActivate: (event) ->
    @_setSelectedItem(event.detail.item)

  _onTap: (event) ->
    @open() if (Polymer.Gestures.findOriginalTarget(event) == @)

  _computeSelectedItemLabel: (selectedItem) ->
    return '' if !selectedItem

    selectedItem.label || selectedItem.textContent.trim()

  _computeMenuVerticalOffset: (noLabelFloat) ->
    if noLabelFloat then -4 else 16


