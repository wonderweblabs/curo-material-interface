'use strict'

# Polymer
polymerObj =

  is: 'cmi-dialog-scrollable'

  properties:
    dialogElement:
      type: Object,
      value: -> @parentNode

  listeners:
    'scrollable.scroll': '_onScroll'
    'iron-resize': '_onIronResize'


  getScrollTarget: ->
    @.$.scrollable

  attached: ->
    @classList.add('no-padding')
    @dialogElement.sizingTarget = @getScrollTarget()

    requestAnimationFrame( ( =>
      @.$.scrollable.classList.add('fit') if @offsetHeight > 0
      @_scroll()
    ).bind(this))

  _scroll: ->
    @toggleClass('is-scrolled', @getScrollTarget().scrollTop > 0)
    @toggleClass('can-scroll', @getScrollTarget().offsetHeight < @getScrollTarget().scrollHeight)
    @toggleClass('scrolled-to-bottom', @getScrollTarget().scrollTop + @getScrollTarget().offsetHeight >= @getScrollTarget().scrollHeight)

  _onScroll: ->
    @_scroll()

Polymer(polymerObj)