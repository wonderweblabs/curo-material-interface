'use strict'

# Polymer
Polymer

  is: 'cmi-fab'

  extends: 'a'

  behaviors: [
    Polymer.CmiButtonBehavior
  ]

  properties:

    block: { type: Boolean, reflectToAttribute: true, value: false }




