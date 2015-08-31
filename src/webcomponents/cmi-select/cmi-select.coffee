'use strict'

# Polymer
Polymer

  is: 'cmi-select'

  behaviors: [
    Polymer.IronControlState,
    Polymer.IronFormElementBehavior
  ]

  properties:

    ###
    True if the dropdown is open. Otherwise, false.
    ###
    opened:
      type: Boolean
      notify: true
      value: false

    ###
    The label for the dropdown.
    ###
    label:
      type: String

    ###
    The selected for the menu.
    ###
    selected:
      type: String
      notify: true
      reflectToAttribute: true
      observer: '_onSelectedChange'

    ###
    The placeholder for the dropdown.
    ###
    placeholder:
      type: String

  _onCmiDropdownMenuSelect: ->
    @selected = @.$.menu.selectedItem.getAttribute('value')

  _onSelectedChange: ->
    @value = @selected
