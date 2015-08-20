'use strict'

# Polymer
Polymer

  is: 'cmi-card-content'

  behaviors: [
    Polymer.CmiCardContentBehavior
  ]

  properties:
    'no-padding': { type: Boolean, reflectToAttribute: true, value: false }
