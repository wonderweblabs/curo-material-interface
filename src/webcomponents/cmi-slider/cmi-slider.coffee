'use strict'

Polymer

  is: 'cmi-slider'

  properties:
    snaps:              { type: Boolean, value: false, notify: true }
    pin:                { type: Boolean, value: false, notify: true }
    secondaryProgress:  { type: Number, value: 0, notify: true, observer: '_secondaryProgressChanged' }
    editable:           { type: Boolean, value: false }
    immediateValue:     { type: Number, value: 0, readOnly: true }
    maxMarkers:         { type: Number, value: 0, notify: true, observer: '_maxMarkersChanged' }
    expand:             { type: Boolean, value: false, readOnly: true }
    dragging:           { type: Boolean, value: false, readOnly: true }
    transiting:         { type: Boolean, value: false, readOnly: true }
    markers:            { type: Array, readOnly: true, value: [] }

  behaviors: [
    Polymer.IronFormElementBehavior,
    Polymer.PaperInkyFocusBehavior,
    Polymer.IronRangeBehavior
  ]

  observers: [
    '_updateKnob(value, min, max, snaps, step)',
    '_minChanged(min)',
    '_maxChanged(max)',
    '_valueChanged(value)',
    '_immediateValueChanged(immediateValue)'
  ]

  hostAttributes:
    role:     'slider'
    tabindex: 0

  keyBindings:
    'left down pagedown home':  '_decrementKey'
    'right up pageup end':      '_incrementKey'

  ready: ->
    @async( =>
      @_updateKnob(@value);
    , 1)

  increment: ->
    @value = @_clampValue(@value + @step)

  decrement: ->
    @value = @_clampValue(@value - @step)

  _updateKnob: (value) ->
    @_positionKnob(@_calcRatio(value))

  _minChanged: ->
    @setAttribute('aria-valuemin', @min)

  _maxChanged: ->
    @setAttribute('aria-valuemax', @max)

  _valueChanged: ->
    @setAttribute('aria-valuenow', @value)
    @fire('value-change')

  _immediateValueChanged: ->
    if  @dragging
      @fire('immediate-value-change')
    else
      @value = @immediateValue

  _secondaryProgressChanged: ->
    @secondaryProgress = @_clampValue(@secondaryProgress)

  _fixForInput: (immediateValue) ->
    @immediateValue.toString()

  _expandKnob: ->
    @_setExpand(true)

  _resetKnob: ->
    @cancelDebouncer('expandKnob')
    @_setExpand(false)

  _positionKnob: (ratio) ->
    @_setImmediateValue(@_calcStep(@_calcKnobPosition(ratio)))
    @_setRatio(@_calcRatio(@immediateValue))

    @.$.sliderKnob.style.left = (@ratio * 100) + '%'

  _inputChange: ->
    @value = @.$$('#input').value
    @fire('change')

  _calcKnobPosition: (ratio) ->
    (@max - @min) * ratio + @min

  _onTrack: (event) ->
    event.stopPropagation()

    switch event.detail.state
      when 'start' then @_trackStart(event)
      when 'track' then @_trackX(event)
      when 'end' then @_trackEnd()

  _trackStart: (event) ->
    @_w = @.$.sliderBar.offsetWidth
    @_x = @ratio * @_w
    @_startx = @_x || 0
    @_minx = - @_startx
    @_maxx = @_w - @_startx
    @.$.sliderKnob.classList.add('dragging')

    @_setDragging(true)

  _trackX: (e) ->
    @_trackStart(e) if !@dragging

    dx = Math.min(@_maxx, Math.max(@_minx, e.detail.dx))
    @_x = @_startx + dx

    immediateValue = @_calcStep(@_calcKnobPosition(@_x / @_w))
    @_setImmediateValue(immediateValue)

    translateX = ((@_calcRatio(immediateValue) * @_w) - @_startx)
    @translate3d(translateX + 'px', 0, 0, @.$.sliderKnob)

  _trackEnd: ->
    s = @.$.sliderKnob.style

    @.$.sliderKnob.classList.remove('dragging')
    @_setDragging(false)
    @_resetKnob()
    @value = @immediateValue

    s.transform = s.webkitTransform = ''

    @fire('change')

  _knobdown: (event) ->
    @_expandKnob()

    event.preventDefault()

    @focus()

  _bardown: (event) ->
    @_w = @.$.sliderBar.offsetWidth
    rect = @.$.sliderBar.getBoundingClientRect()
    ratio = (event.detail.x - rect.left) / @_w
    prevRatio = @ratio

    @_setTransiting(true)

    @_positionKnob(ratio)

    @debounce('expandKnob', @_expandKnob, 60)

    @_setTransiting(false) if prevRatio == @ratio

    @async => @fire('change')

    event.preventDefault()

  _knobTransitionEnd: (event) ->
    @_setTransiting(false) if event.target == @.$.sliderKnob

  _maxMarkersChanged: (maxMarkers) ->
    l = (@max - @min) / @step

    if !@snaps && l > maxMarkers
      @_setMarkers([])
    else
      @_setMarkers(new Array(l))

  _mergeClasses: (classes) ->
    Object.keys(classes).filter( (className) ->
      classes[className]
    ).join(' ')

  _getClassNames: ->
    classes = {}

    classes.disabled = @disabled
    classes.pin = @pin
    classes.snaps = @snaps
    classes.ring = @immediateValue <= @min
    classes.expand = @expand
    classes.dragging = @dragging
    classes.transiting = @transiting
    classes.editable = @editable

    @_mergeClasses(classes)

  _getProgressClass: ->
    @_mergeClasses
      transiting: @transiting

  _incrementKey: (event) ->
    if event.detail.key == 'end'
      @value = @max
    else
      @increment()

    @fire('change')

  _decrementKey: (event) ->
    if event.detail.key == 'home'
      @value = @min
    else
      @decrement()

    @fire('change')


