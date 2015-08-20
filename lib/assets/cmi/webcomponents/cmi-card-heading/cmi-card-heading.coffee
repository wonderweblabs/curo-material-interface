'use strict'

# Polymer
Polymer

  is: 'cmi-card-heading'

  behaviors: [
    Polymer.CmiCardContentBehavior
  ]

  properties:
    image:        { type: String, value: '' }
    'image-alt':  { type: String, value: '' }
    'pull-up':    { type: Boolean, value: false, reflectToAttribute: true }

