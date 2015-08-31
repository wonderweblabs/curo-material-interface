'use strict'

Polymer

  is: 'cmi-card-image'

  properties:
    image:      { type: String, value: '' }
    imageAlt:   { type: String, value: '' }
    titleTheme: { type: String, reflectToAttribute: true, value: 'default' }