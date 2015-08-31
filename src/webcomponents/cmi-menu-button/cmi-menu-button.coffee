'use strict'

CmiMenuButton = Polymer

  is: 'cmi-menu-button'

  behaviors: [
    Polymer.IronA11yKeysBehavior,
    Polymer.IronControlState
  ]

  properties:
    opened:
      type: Boolean
      value: false
      notify: true
      observer: '_openedChanged'
    horizontalAlign:
      type: String
      value: 'left'
      reflectToAttribute: true
    verticalAlign:
      type: String
      value: 'top'
      reflectToAttribute: true
    horizontalOffset:
      type: Number
      value: 0
      notify: true
    verticalOffset:
      type: Number
      value: 0
      notify: true
    noAnimations:
      type: Boolean
      value: false
    ignoreActivate:
      type: Boolean
      value: false
    openAnimationConfig:
      type: Object
      value: ->
        [{
          name: 'fade-in-animation'
          timing:
            delay: 100
            duration: 200
        }, {
          name: 'cmi-menu-grow-width-animation'
          timing:
            delay: 100
            duration: 150
            easing: CmiMenuButton.ANIMATION_CUBIC_BEZIER
        }, {
          name: 'cmi-menu-grow-height-animation'
          timing:
            delay: 100
            duration: 275
            easing: CmiMenuButton.ANIMATION_CUBIC_BEZIER
        }]
    closeAnimationConfig:
      type: Object
      value: ->
        [{
          name: 'fade-out-animation'
          timing:
            duration: 150
        }, {
          name: 'cmi-menu-shrink-width-animation'
          timing:
            delay: 100
            duration: 50
            easing: CmiMenuButton.ANIMATION_CUBIC_BEZIER
        }, {
          name: 'cmi-menu-shrink-height-animation'
          timing:
            duration: 200
            easing: 'ease-in'
        }]

  hostAttributes:
    role: 'group'
    'aria-haspopup': 'true'

  listeners:
    'iron-activate': '_onIronActivate'

  open: ->
    return if @disabled

    @.$.dropdown.open()

  close: ->
    @.$.dropdown.close()

  _onIronActivate: (event) ->
    @close() if !@ignoreActivate

  _openedChanged: (opened, oldOpened) ->
    if opened
      @fire('cmi-dropdown-open')
    else if oldOpened != null
      @fire('cmi-dropdown-close')

  _disabledChanged: (disabled) ->
    Polymer.IronControlState._disabledChanged.apply(this, arguments)

    @close() if disabled && @opened


CmiMenuButton.ANIMATION_CUBIC_BEZIER = 'cubic-bezier(.3,.95,.5,1)'
CmiMenuButton.MAX_ANIMATION_TIME_MS = 400

Polymer.CmiMenuButton = CmiMenuButton