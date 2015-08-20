'use strict'

# Polymer
Polymer

  is: 'cmi-card-image'

  behaviors: [
    Polymer.CmiCardContentBehavior
  ]

  properties:
    image:      { type: String, value: '' }
    imageAlt:   { type: String, value: '' }
    titleTheme: { type: String, reflectToAttribute: true, value: 'default' }