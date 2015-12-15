'use strict'

Polymer

  is: 'cmi-slider'

  properties:
    snaps:              { type: Boolean, value: false, notify: true }
    pin:                { type: Boolean, value: false, notify: true }
    secondaryProgress:  { type: Number, value: 0, notify: true, observer: '_secondaryProgressChanged' }
    editable:           { type: Boolean, value: false }
    immediateValue:     { type: Number, value: 0, notify: true, readOnly: true }
    maxMarkers:         { type: Number, value: 0, notify: true, observer: '_maxMarkersChanged' }
    expand:             { type: Boolean, value: false, readOnly: true }
    dragging:           { type: Boolean, value: false, readOnly: true }
    transiting:         { type: Boolean, value: false, readOnly: true }
    markers:            { type: Array, readOnly: true, value: [] }

  behaviors: [
    Polymer.IronA11yKeysBehavior,
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

  ###
  Increases value by `step` but not above `max`.
  @method increment
  ###
  increment: ->
    @value = @_clampValue(@value + @step)

  ###
  Decreases value by `step` but not below `min`.
  @method decrement
  ###
  decrement: ->
    @value = @_clampValue(@value - @step)

  _updateKnob: (value, min, max, snaps, step) ->
    @setAttribute 'aria-valuemin', min
    @setAttribute 'aria-valuemax', max
    @setAttribute 'aria-valuenow', value

    @_positionKnob(@_calcRatio(value))

  _valueChanged: ->
    @setAttribute('aria-valuenow', @value)
    @fire('value-change')

  _minChanged: ->
    @setAttribute('aria-valuemin', @min)

  _maxChanged: ->
    @setAttribute('aria-valuemax', @max)

  _immediateValueChanged: ->
    if  @dragging
      @fire('immediate-value-change')
    else
      @value = @immediateValue

  _secondaryProgressChanged: ->
    @secondaryProgress = @_clampValue(@secondaryProgress)

  _expandKnob: ->
    @_setExpand(true)

  # _fixForInput: (immediateValue) ->
  #   @immediateValue.toString()

  _resetKnob: ->
    @cancelDebouncer('expandKnob')
    @_setExpand(false)

  _positionKnob: (ratio) ->
    @_setImmediateValue(@_calcStep(@_calcKnobPosition(ratio)))
    @_setRatio(@_calcRatio(@immediateValue))

    @.$.sliderKnob.style.left = (@ratio * 100) + '%'

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

    # update knob's position
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

    event.preventDefault() #cancel selection

    @focus() #set the focus manually because we will called prevent default

  _bardown: (event) ->
    @_w = @.$.sliderBar.offsetWidth
    rect = @.$.sliderBar.getBoundingClientRect()
    ratio = (event.detail.x - rect.left) / @_w
    prevRatio = @ratio

    @_setTransiting(true)
    @_positionKnob(ratio)

    @debounce('expandKnob', @_expandKnob, 60)

    # if the ratio doesn't change, sliderKnob's animation won't start
    # and `_knobTransitionEnd` won't be called
    # Therefore, we need to manually update the `transiting` state
    @_setTransiting(false) if prevRatio == @ratio

    @async => @fire('change')

    event.preventDefault() # cancel selection

  _knobTransitionEnd: (event) ->
    @_setTransiting(false) if event.target == @.$.sliderKnob

  _maxMarkersChanged: (maxMarkers) ->
    @_setMarkers([]) if !@snaps

    steps = Math.floor((@max - @min) / @step)
    steps = maxMarkers if steps > maxMarkers

    @_setMarkers(new Array(steps))

  _mergeClasses: (classes) ->
    Object.keys(classes).filter( (className) ->
      classes[className]
    ).join(' ')

  _getClassNames: ->
    classes = {}

    classes.disabled    = @disabled
    classes.pin         = @pin
    classes.snaps       = @snaps
    classes.ring        = @immediateValue <= @min
    classes.expand      = @expand
    classes.dragging    = @dragging
    classes.transiting  = @transiting
    classes.editable    = @editable

    @_mergeClasses(classes)

  _incrementKey: (event) ->
    return if @disabled

    if event.detail.key == 'end'
      @value = @max
    else
      @increment()

    @fire('change')

  _decrementKey: (event) ->
    return if @disabled

    if event.detail.key == 'home'
      @value = @min
    else
      @decrement()

    @fire('change')

  _changeValue: (event) ->
    @value = event.target.value
    @fire('change')

  _inputKeyDown: (event) ->
    event.stopPropagation()

  # create the element ripple inside the `sliderKnob`
  _createRipple: ->
    @_rippleContainer = @.$.sliderKnob

    Polymer.PaperInkyFocusBehaviorImpl._createRipple.call(@)

  # Hide the ripple when user is not interacting with keyboard.
  # This behavior is different from other ripple-y controls, but is
  # according to spec: https://www.google.com/design/spec/components/sliders.html
  _focusedChanged: (receivedFocusFromKeyboard) ->
    @ensureRipple() if receivedFocusFromKeyboard

    if @hasRipple()
      # note, ripple must be un-hidden prior to setting `holdDown`
      if receivedFocusFromKeyboard
        @_ripple.removeAttribute('hidden')
      else
        @_ripple.setAttribute('hidden', '')

      @_ripple.holdDown = receivedFocusFromKeyboard

  # _getProgressClass: ->
  #   @_mergeClasses
  #     transiting: @transiting


