'use strict'

# Polymer
Polymer

  is: 'cmi-card'

  properties:
    elevation:      { type: Number, value: 1 }
    animatedShadow: { type: Boolean, value: false }
    theme:          { type: String, reflectToAttribute: true, value: 'default' }
    block:          { type: Boolean, reflectToAttribute: true, value: false }

