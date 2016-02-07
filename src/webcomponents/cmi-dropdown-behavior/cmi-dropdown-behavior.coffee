'use strict'

CmiDropdownBehaviorConfig = {}
CmiDropdownBehaviorConfig.ANIMATION_CUBIC_BEZIER = 'cubic-bezier(.3,.95,.5,1)'
CmiDropdownBehaviorConfig.MAX_ANIMATION_TIME_MS = 400

###
  `Polymer.CmiDropdownBehavior`

  @polymerBehavior Polymer.CmiDropdownBehavior
###
Polymer.CmiDropdownBehaviorImpl =

  properties:
    opened:
      type: Boolean
      value: false
      notify: true
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
          name: 'paper-menu-grow-width-animation'
          timing:
            delay: 100
            duration: 150
            easing: CmiDropdownBehaviorConfig.ANIMATION_CUBIC_BEZIER
        }, {
          name: 'paper-menu-grow-height-animation'
          timing:
            delay: 100
            duration: 275
            easing: CmiDropdownBehaviorConfig.ANIMATION_CUBIC_BEZIER
        }]
    closeAnimationConfig:
      type: Object
      value: ->
        return [{
          name: 'fade-out-animation'
          timing:
            duration: 150
        }, {
          name: 'paper-menu-shrink-width-animation'
          timing:
            delay: 100
            duration: 50
            easing: CmiDropdownBehaviorConfig.ANIMATION_CUBIC_BEZIER
        }, {
          name: 'paper-menu-shrink-height-animation'
          timing:
            duration: 200
            easing: 'ease-in'
        }]

  hostAttributes:
    'aria-haspopup': 'true'

  listeners:
    'iron-activate': '_onDropdownBehaviorIronActivate'

  open: ->
    return if @disabled

    @.$.dropdown.open()

  close: ->
    @.$.dropdown.close()

  _onDropdownBehaviorIronActivate: (event) ->
    @close() if !@ignoreActivate

  _openedChanged: (opened, oldOpened) ->
    if opened
      @fire('cmi-dropdown-behavior-open')
    else if oldOpened != null
      @fire('cmi-dropdown-behavior-close')

  _disabledChanged: (disabled) ->
    Polymer.IronControlState._disabledChanged.apply(this, arguments)

    @close() if disabled && @opened


###
  @polymerBehavior Polymer.CmiDropdownBehavior
###
Polymer.CmiDropdownBehavior = [
  Polymer.CmiDropdownBehaviorImpl
]


