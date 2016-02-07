'use strict'

# this would be the only `paper-drawer-panel` in
# the whole app that can be in `dragging` state
sharedPanel = null

# collect class names of the passed object
classNames = (obj) ->
  classes = []

  for key in Object.keys(obj)
    if obj.hasOwnProperty(key) && obj[key]
      classes.push(key)

  classes.join(' ')

# Polymer
Polymer

  is: 'cmi-drawer-navigation'

  properties:

    disableEdgeSwipe:
      type: Boolean
      value: false
    disableSwipe:
      type: Boolean
      value: false
    dragging:
      type: Boolean
      value: false
      readOnly: true
      notify: true

    # new
    drawerLeftWidth:
      type: String
      value: '256px'
    #new
    drawerRightWidth:
      type: String
      value: '256px'

    edgeSwipeSensitivity:
      type: Number
      value: 30
    hasTransform:
      type: Boolean
      value: -> 'transform' in @style
    hasWillChange:
      type: Boolean
      value: -> 'willChange' in @style
    peeking:
      type: Boolean
      value: false
      readOnly: true
      notify: true
    selected:
      reflectToAttribute: true
      notify: true
      type: String
      value: 'drawer_main'

    # new
    drawerLeftToggleAttribute:
      type: String
      value: 'cmi-drawer-navigation-toggle-left'
    # new
    drawerRightToggleAttribute:
      type: String
      value: 'cmi-drawer-navigation-toggle-right'

    # animate or not
    transition:
      type: Boolean
      value: false

  listeners:
    tap: '_onTap'
    track: '_onTrack'
    down: '_downHandler'
    up: '_upHandler'



  # Toggles the panel open and closed.
  togglePanel: (type = 'drawer_left') ->
    if @selected == type || type == 'drawer_main'
      @closeDrawer()
    else
      @openDrawer(type)

  # Opens the drawer.
  openDrawer: (type = 'drawer_left') ->
    @selected = type

  # Closes the drawer.
  closeDrawer: ->
    @selected = 'drawer_main'

  # Polymer element ready
  ready: ->
    # Avoid transition at the beginning e.g. page loads and enable
    # transitions only after the element is rendered and ready.
    @transition = true

  # gives the classes for the iron selector
  getIronSelectorClasses: (dragging, transition, peeking, selected) ->
    classes =
      dragging: dragging
      transition: transition
      peeking: peeking

    classes[selected.replace('_', '-')] = true

    classNames(classes)

  # gives the style for the drawer
  getDrawerStyle: (type = 'left', drawerWidth) ->
    "width: #{drawerWidth}"

  # gives the style for the main element
  getMainStyle: (selected, drawerLeftWidth, drawerRightWidth) ->
    transform = '0px'

    if selected == "drawer_left"
      transform = "#{drawerLeftWidth}"
    else if selected == "drawer_right"
      transform = "-#{drawerLeftWidth}"

    transform = @_transformForTranslateX(transform).replace('pxpx', 'px')
    style = []
    style.push "-webkit-transform: #{transform};"
    style.push "-moz-transform: #{transform};"
    style.push "-ms-transform: #{transform};"
    style.push "-o-transform: #{transform};"
    style.push "transform: #{transform};"
    style.join('')

  _computeSwipeOverlayHidden: (disableEdgeSwipe) ->
    disableEdgeSwipe

  _onTrack: (event) ->
    return if sharedPanel && @ != sharedPanel

    switch event.detail.state
      when 'start' then @_trackStart(event)
      when 'track' then @_trackX(event)
      when 'end' then @_trackEnd(event)

  _swipeAllowed: ->
    !@disableSwipe

  _isMainSelected: ->
    @selected == 'drawer_main'

  _startEdgePeek: ->
    if event.detail.x > @offsetWidth / 2
      @width = @$.drawer_right.offsetWidth
      drawer = @$.drawer_right
      translate = @_translateXForDeltaX(@edgeSwipeSensitivity * -1, 'right')
    else
      @width = @$.drawer_left.offsetWidth
      drawer = @$.drawer_left
      translate = @_translateXForDeltaX(@edgeSwipeSensitivity, 'left')

    @_moveDrawer(translate, drawer)
    @_setPeeking(true)

  _stopEdgePeek: ->
    if @peeking
      @_setPeeking(false)
      @_moveDrawer(null)

  _downHandler: (event) ->
    if !@dragging && @_isMainSelected() && @_isEdgeTouch(event) && !sharedPanel
      @_startEdgePeek()
      # cancel selection
      event.preventDefault()
      # grab this panel
      sharedPanel = @

  _upHandler: ->
    @_stopEdgePeek()
    # release the panel
    sharedPanel = null

  _onTap: (event) ->
    target = Polymer.dom(event).localTarget

    if target && @drawerLeftToggleAttribute && target.hasAttribute(@drawerLeftToggleAttribute)
      @togglePanel('drawer_left')
      return

    if target && @drawerRightToggleAttribute && target.hasAttribute(@drawerRightToggleAttribute)
      @togglePanel('drawer_right')
      return


  _isEdgeTouch: (event) ->
    return false if @disableEdgeSwipe
    return false unless @_swipeAllowed()

    x = event.detail.x

    if x > @offsetWidth / 2
      x >= @offsetWidth - @edgeSwipeSensitivity
    else
      x <= @edgeSwipeSensitivity

  _trackStart: (event) ->
    return unless @_swipeAllowed()

    sharedPanel = @
    @_setDragging(true)

    @_setDragging(@peeking || @_isEdgeTouch(event)) if @_isMainSelected()

    if event.detail.x > @offsetWidth / 2
      @width = @$.drawer_right.offsetWidth
    else
      @width = @$.drawer_left.offsetWidth

    @transition = false

  _translateXForDeltaX: (deltaX, type = 'left') ->
    isMain = @_isMainSelected()

    if type == 'left'
      r = Math.min(0, if isMain then deltaX - @width else deltaX)
    else
      r = Math.max(0, if isMain then @width + deltaX else deltaX)

    r

  _trackX: (event) ->
    return unless @dragging

    dx = event.detail.dx

    if @peeking
      return if Math.abs(dx) <= @edgeSwipeSensitivity

      @_setPeeking(false)

    if event.detail.x > @offsetWidth / 2
      @_moveDrawer(@_translateXForDeltaX(dx, 'right'), @$.drawer_right)
    else
      @_moveDrawer(@_translateXForDeltaX(dx, 'left'), @$.drawer_left)

  _trackEnd: (event) ->
    return unless @dragging

    @_setDragging(false)
    @transition = true
    sharedPanel = null
    @_moveDrawer(null)

    if event.detail.x > @offsetWidth / 2
      xDirection = event.detail.dx < 0
      if xDirection then @openDrawer('drawer_right') else @closeDrawer()
    else
      xDirection = event.detail.dx > 0
      if xDirection then @openDrawer('drawer_left') else @closeDrawer()

  _transformForTranslateX: (translateX) ->
    return '' if translateX == null

    if @hasWillChange
      'translateX(' + translateX + 'px)'
    else
      'translate3d(' + translateX + 'px, 0, 0)'

  _moveDrawer: (translateX, drawer = null) ->
    if drawer == null
      @transform(@_transformForTranslateX(translateX), @$.drawer_left)
      @transform(@_transformForTranslateX(translateX), @$.drawer_right)
    else
      @transform(@_transformForTranslateX(translateX), drawer)

    if drawer == @$.drawer_left
      translateX = @$.drawer_left.offsetWidth + translateX
      @transform(@_transformForTranslateX(translateX), @$.drawer_main)
    else if drawer == @$.drawer_right
      translateX = translateX - @$.drawer_right.offsetWidth
      @transform(@_transformForTranslateX(translateX), @$.drawer_main)
    else
      @transform(@_transformForTranslateX(0), @$.drawer_main)




