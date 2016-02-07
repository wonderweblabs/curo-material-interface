'use strict'

Polymer

  is: 'cmi-card-content'

  behaviors: [
    Polymer.CmiCardContentBehavior
  ]

  properties:
    noPadding: { type: Boolean, reflectToAttribute: true, value: false }
