'use strict'

# Polymer
Polymer

  is: 'cmi-input'

  behaviors: [
    Polymer.IronFormElementBehavior,
    Polymer.PaperInputBehavior,
    Polymer.IronControlState
  ]

  properties:

    ###*
    *
    ###
    hintMessage: { type: String, value: null }