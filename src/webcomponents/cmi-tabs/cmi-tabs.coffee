'use strict'

# Polymer
Polymer

  is: 'cmi-tabs'

  behaviors: [
    Polymer.IronResizableBehavior,
    Polymer.IronMenubarBehavior
  ]

  properties:
    noink:
      type: Boolean,
      value: false
    noBar:
      type: Boolean,
      value: false
    noSlide:
      type: Boolean,
      value: false
    scrollable:
      type: Boolean,
      value: false
    disableDrag:
      type: Boolean,
      value: false
    hideScrollButtons:
      type: Boolean,
      value: false
    alignBottom:
      type: Boolean,
      value: false
    selected:
      type: String,
      notify: true
    selectable:
      type: String,
      value: 'paper-tab'
    _step:
      type: Number,
      value: 10
    _holdDelay:
      type: Number,
      value: 1
    _leftHidden:
      type: Boolean,
      value: false
    _rightHidden:
      type: Boolean,
      value: false
    _previousTab:
      type: Object

  hostAttributes:
    role: 'tablist'

  listeners:
    'iron-resize': '_onResize'
    'iron-select': '_onIronSelect'
    'iron-deselect': '_onIronDeselect'


  _computeScrollButtonClass: (hideThisButton, scrollable, hideScrollButtons) ->
    return 'hidden' if !scrollable || hideScrollButtons
    return 'not-visible' if hideThisButton

    ''

  _computeTabsContentClass: (scrollable) ->
    if scrollable then 'scrollable' else 'horizontal layout'

  _computeSelectionBarClass: (noBar, alignBottom) ->
    return 'hidden' if noBar
    return 'align-bottom' if alignBottom

    null

  _onResize: ->
    @debounce '_onResize', =>
      @_scroll()
      @_tabChanged(@selectedItem)
    , 10

  _onIronSelect: (event) ->
    @_tabChanged(event.detail.item, @_previousTab)
    @_previousTab = event.detail.item
    @cancelDebouncer('tab-changed')

  _onIronDeselect: (event) ->
    @debounce('tab-changed', =>
      @_tabChanged(null, @_previousTab)
    , 1)

  getTabContainerScrollSize: ->
    Math.max(0, @.$.tabsContainer.scrollWidth - @.$.tabsContainer.offsetWidth)

  _scroll: ->
    return if !@scrollable

    scrollLeft = @.$.tabsContainer.scrollLeft

    @_leftHidden = scrollLeft == 0
    @_rightHidden = scrollLeft == @getTabContainerScrollSize()

  _onLeftScrollButtonDown: ->
    @_holdJob = setInterval(@_scrollToLeft.bind(@), @_holdDelay)

  _onRightScrollButtonDown: ->
    @_holdJob = setInterval(@_scrollToRight.bind(@), @_holdDelay)

  _onScrollButtonUp: ->
    clearInterval(@_holdJob)
    @_holdJob = null

  _scrollToLeft: ->
    @.$.tabsContainer.scrollLeft -= @_step

  _scrollToRight: ->
    @.$.tabsContainer.scrollLeft += @_step

  _tabChanged: (tab, old) ->
    if !tab
      @_positionBar(0, 0)
      return

    r = @.$.tabsContent.getBoundingClientRect()
    w = r.width
    tabRect = tab.getBoundingClientRect()
    tabOffsetLeft = tabRect.left - r.left

    @_pos =
      width: @_calcPercent(tabRect.width, w),
      left: @_calcPercent(tabOffsetLeft, w)

    if @noSlide || old == null
      @_positionBar(@_pos.width, @_pos.left)
      return

    oldRect = old.getBoundingClientRect()
    oldIndex = @items.indexOf(old)
    index = @items.indexOf(tab)
    m = 5

    @.$.selectionBar.classList.add('expand')

    if oldIndex < index
      @_positionBar(@_calcPercent(tabRect.left + tabRect.width - oldRect.left, w) - m, @_left)
    else
      @_positionBar(@_calcPercent(oldRect.left + oldRect.width - tabRect.left, w) - m, @_calcPercent(tabOffsetLeft, w) + m)

    if @scrollable
      @_scrollToSelectedIfNeeded(tabRect.width, tabOffsetLeft)

  _scrollToSelectedIfNeeded: (tabWidth, tabOffsetLeft) ->
    l = tabOffsetLeft - @.$.tabsContainer.scrollLeft

    if l < 0
      @.$.tabsContainer.scrollLeft += l
    else
      l += (tabWidth - @.$.tabsContainer.offsetWidth)

      @.$.tabsContainer.scrollLeft += l if l > 0

  _calcPercent: (w, w0) ->
    100 * w / w0

  _positionBar: (width, left) ->
    width = width || 0
    left = left || 0

    @_width = width
    @_left = left
    @transform('translate3d(' + left + '%, 0, 0) scaleX(' + (width / 100) + ')', @.$.selectionBar)

  _onBarTransitionEnd: (e) ->
    cl = @.$.selectionBar.classList

    if cl.contains('expand')
      cl.remove('expand')
      cl.add('contract')
      @_positionBar(@_pos.width, @_pos.left)
    else if cl.contains('contract')
      cl.remove('contract')



