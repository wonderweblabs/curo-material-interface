'use strict'

# Polymer
Polymer

  is: 'cmi-card-heading'

  behaviors: [
    Polymer.CmiCardContentBehavior
  ]

  properties:
    image:     { type: String, value: '' }
    imageAlt:  { type: String, value: '' }
    pullUp:    { type: Boolean, value: false, reflectToAttribute: true }

