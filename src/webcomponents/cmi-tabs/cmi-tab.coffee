'use strict'

Polymer

  is: 'cmi-tab'

  properties:
    noink:
      type: Boolean,
      value: false
    badgeValue:
      type: String,
      value: ''

  behaviors: [
    Polymer.IronControlState
  ]

  hostAttributes:
    role: 'tab'

  listeners:
    down: '_onDown'

  getParentNoInk: ->
    parent = Polymer.dom(@).parentNode

    !!parent && !!parent.noink

  _onDown: (e) ->
    @noink = !!@noink || !!@getParentNoInk()
