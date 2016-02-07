'use strict'

Polymer

  is: 'cmi-item'

  hostAttributes:
    role: 'option'
    tabindex: 0

  behaviors: [
    Polymer.IronControlState,
    Polymer.IronButtonState,
  ]