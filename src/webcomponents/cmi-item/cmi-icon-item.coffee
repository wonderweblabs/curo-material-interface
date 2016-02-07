'use strict'

Polymer

  is: 'cmi-icon-item'

  hostAttributes:
    role: 'option'
    tabindex: 0

  behaviors: [
    Polymer.IronControlState,
    Polymer.IronButtonState,
  ]