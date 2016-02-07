'use strict'

###
  Polymer.CmiCardContentBehavior` implements general features for cmi card
  content elements like cmi-card-content or cmi-card-headline.

  @polymerBehavior Polymer.CmiCardContentBehavior
###
Polymer.CmiCardContentBehaviorImpl =

  properties:

    lineTop: { type: Boolean, reflectToAttribute: true, value: false }

###
  @polymerBehavior Polymer.CmiCardContentBehavior
###
Polymer.CmiCardContentBehavior = [
  Polymer.CmiCardContentBehaviorImpl
]