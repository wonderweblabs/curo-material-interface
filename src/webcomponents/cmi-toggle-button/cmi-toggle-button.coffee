'use strict'

Polymer

  is: 'cmi-toggle-button'

  properties:
    checked: { type: Boolean, value: false, reflectToAttribute: true, notify: true, observer: '_checkedChanged' }
    toggles: { type: Boolean, value: true, reflectToAttribute: true }

  behaviors: [
    Polymer.PaperInkyFocusBehavior
  ]

  hostAttributes:
    role:           'button'
    'aria-pressed': 'false'
    tabindex:       0

  listeners:
    track: '_ontrack'

  ready: ->
    @_isReady = true

  _buttonStateChanged: ->
    return if @disabled

    @checked = @active if @_isReady

  _checkedChanged: (checked) ->
    @active = @checked

    @fire 'iron-change'

  _ontrack: (event) ->
    track = event.detail

    if track.state == 'start'
      @_trackStart(track)
    else if track.state == 'track'
      @_trackMove(track)
    else if track.state == 'end'
      @_trackEnd(track)

  _trackStart: (track) ->
    @_width = @.$.toggleBar.offsetWidth / 2
    @_trackChecked = @checked
    @.$.toggleButton.classList.add('dragging')

  _trackMove: (track) ->
    dx = track.dx
    @_x = Math.min(@_width, Math.max(0, if @_trackChecked then @_width + dx else dx))
    @translate3d(@_x + 'px', 0, 0, @.$.toggleButton)
    @_userActivate(@_x > (@_width / 2))

  _trackEnd: (track) ->
    @.$.toggleButton.classList.remove('dragging')
    @transform('', @.$.toggleButton)


