'use strict'

###
  `Polymer.CmiHeadlineBehavior` implements mainly the lined headline feature

  @polymerBehavior Polymer.CmiHeadlineBehavior
###
Polymer.CmiHeadlineBehaviorImpl =

  properties:

    line:   { type: Boolean, reflectToAttribute: true, value: false }


###
  @polymerBehavior Polymer.CmiHeadlineBehavior
###
Polymer.CmiHeadlineBehavior = [
  Polymer.CmiHeadlineBehaviorImpl
]