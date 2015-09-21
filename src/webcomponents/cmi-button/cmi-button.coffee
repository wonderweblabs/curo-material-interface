'use strict'

Polymer

  is: 'cmi-button'

  behaviors: [
    Polymer.CmiButtonBehavior
  ]

  properties:

    ###
    Set to true to stretch full width.
    ###
    block: { type: Boolean, reflectToAttribute: true, value: false }


