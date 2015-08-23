'use strict'

# behavior impl
Polymer.CmiHeadlinesBehaviorImpl =

  properties:

    line:   { type: Boolean, reflectToAttribute: true, value: false }


# Polymer
Polymer.CmiHeadlinesBehavior = [ Polymer.CmiHeadlinesBehaviorImpl ]

