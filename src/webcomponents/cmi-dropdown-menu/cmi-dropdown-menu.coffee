'use strict'

# Polymer
Polymer

  is: 'cmi-dropdown-menu'

  properties:
    entries:
      type: Array
      notify: true
      value: => []
      observer: '_onDropdownMenuEntriesChange'
    label:
      type: String
    placeholder:
      type: String
    alwaysFloatLabel:
      type: Boolean
      value: false
    noLabelFloat:
      type: Boolean
      value: false
      reflectToAttribute: true
    horizontalAlign:
      type: String
      value: 'right'
      reflectToAttribute: true

  behaviors: [
    Polymer.IronControlState,
    Polymer.IronButtonState,
    Polymer.CmiMenuBehavior,
    Polymer.CmiDropdownBehavior
  ]

  # listeners:
  #   'cmi-menu-behavior-select': '_onCmiMenuBehaviorSelect'

  keyBindings:
    'up down': 'open'
    'esc': 'close'

  _onDropdownMenuEntriesChange: ->
    @menuItems = @entries

  _onChildTap: (event) ->
    @open()

  _computeInputValue: (selectedItem) ->
    selectedItem.getAttribute(@titleName)


  # properties:
  #   selectedItem:
  #     type: Object
  #     notify: true
  #     readOnly: true
  #     observer: '_selectedItemChange'
  #   selected:
  #     type: String
  #     notify: true
  #     # observer: '_selectedChange'
  #   selectedItemLabel:
  #     type: String
  #     notify: true
  #     computed: '_computeSelectedItemLabel(selectedItem)'

  # listeners:
  #   'iron-activate': '_onIronActivate'
  #   'tap': '_onTap'

  # keyBindings:
  #   'up down': 'open'
  #   'esc': 'close'

  # hostAttributes:
  #   role: 'group'
  #   'aria-haspopup': 'true'

  # _onIronActivate: (event) ->
  #   @_setSelectedItem(event.detail.item)

  # open: ->
  #   @.$.menuButton.open()

  # close: ->
  #   @.$.menuButton.close()

  # _selectedItemChange: ->
  #   console.log 'cmi-dropdown-select'
  #   @fire 'cmi-dropdown-select'

  # _selectedChange: ->
  #   console.log 'XXXX'

  # _onTap: (event) ->
  #   @open() if (Polymer.Gestures.findOriginalTarget(event) == @)

  # _nameChanged: ->
  #   if @name == null || @name == undefined || @name == '' || @name == ' '
  #     @_formElementUnregister()
  #   else
  #     @_formElementRegister()

  # _computeSelectedItemLabel: (selectedItem) ->
  #   return '' if !selectedItem

  #   selectedItem.label || selectedItem.textContent.trim()

  # _computeMenuVerticalOffset: (noLabelFloat) ->
  #   if noLabelFloat then -4 else 16


