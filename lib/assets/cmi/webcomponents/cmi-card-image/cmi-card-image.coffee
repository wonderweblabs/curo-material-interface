'use strict'

# Polymer
Polymer

  is: 'cmi-card-image'

  behaviors: [
    Polymer.CmiCardContentBehavior
  ]

  properties:
    'image':        { type: String, value: '' }
    'image-alt':    { type: String, value: '' }
    'title-theme':  { type: String, reflectToAttribute: true, value: 'default' }