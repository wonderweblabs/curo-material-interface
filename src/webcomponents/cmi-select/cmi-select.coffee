'use strict'

# Polymer
Polymer

  is: 'cmi-select'

  properties:
    options:
      type: Array
      notify: true
      value: => []
      observer: '_onSelectOptionsChange'


  behaviors: [
    Polymer.IronControlState,
    Polymer.IronButtonState,
    Polymer.CmiMenuBehavior,
    Polymer.CmiDropdownBehavior
  ]

  _onSelectOptionsChange: ->
    @menuItems = @options
