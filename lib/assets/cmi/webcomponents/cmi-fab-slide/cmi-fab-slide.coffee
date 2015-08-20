'use strict'

# Polymer
Polymer

  is: 'cmi-fab-slide'

  behaviors: [
    Polymer.CmiButtonBehavior
  ]

  properties:
    open: { type: Boolean, reflectToAttribute: true, value: false }
    hover: { type: Boolean, value: false }

  ready: ->
    @addEventListener('mouseenter', @onMouseEnter, @)
    @addEventListener('mouseleave', @onMouseLeave, @)

  onMouseEnter: (event) ->
    return unless @hover == true
    return if @open == true

    @open = true

  onMouseLeave: ->
    return unless @hover == true
    return if @open == false

    @open = false
