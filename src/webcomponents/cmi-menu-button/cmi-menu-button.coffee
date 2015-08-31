(->
  "use strict"

  CmiMenuButton = Polymer(

    is: "cmi-menu-button"

    ###
    Fired when the dropdown opens.

    @event paper-dropdown-open
    ###

    ###
    Fired when the dropdown closes.

    @event paper-dropdown-close
    ###
    behaviors: [
      Polymer.IronA11yKeysBehavior,
      Polymer.IronControlState
    ]

    properties:

      ###
      True if the content is currently displayed.
      ###
      opened:
        type: Boolean
        value: false
        notify: true
        observer: "_openedChanged"


      ###
      The orientation against which to align the menu dropdown
      horizontally relative to the dropdown trigger.
      ###
      horizontalAlign:
        type: String
        value: "left"
        reflectToAttribute: true


      ###
      The orientation against which to align the menu dropdown
      vertically relative to the dropdown trigger.
      ###
      verticalAlign:
        type: String
        value: "top"
        reflectToAttribute: true


      ###
      A pixel value that will be added to the position calculated for the
      given `horizontalAlign`. Use a negative value to offset to the
      left, or a positive value to offset to the right.
      ###
      horizontalOffset:
        type: Number
        value: 0
        notify: true


      ###
      A pixel value that will be added to the position calculated for the
      given `verticalAlign`. Use a negative value to offset towards the
      top, or a positive value to offset towards the bottom.
      ###
      verticalOffset:
        type: Number
        value: 0
        notify: true


      ###
      Set to true to disable animations when opening and closing the
      dropdown.
      ###
      noAnimations:
        type: Boolean
        value: false


      ###
      Set to true to disable automatically closing the dropdown after
      a selection has been made.
      ###
      ignoreSelect:
        type: Boolean
        value: false


      ###
      An animation config. If provided, this will be used to animate the
      opening of the dropdown.
      ###
      openAnimationConfig:
        type: Object
        value: ->
          [
            name: "fade-in-animation"
            timing:
              delay: 100
              duration: 200
          ,
            name: "cmi-menu-grow-width-animation"
            timing:
              delay: 100
              duration: 150
              easing: CmiMenuButton.ANIMATION_CUBIC_BEZIER
          ,
            name: "cmi-menu-grow-height-animation"
            timing:
              delay: 100
              duration: 275
              easing: CmiMenuButton.ANIMATION_CUBIC_BEZIER
           ]


      ###
      An animation config. If provided, this will be used to animate the
      closing of the dropdown.
      ###
      closeAnimationConfig:
        type: Object
        value: ->
          [
            name: "fade-out-animation"
            timing:
              duration: 150
          ,
            name: "cmi-menu-shrink-width-animation"
            timing:
              delay: 100
              duration: 50
              easing: CmiMenuButton.ANIMATION_CUBIC_BEZIER
          ,
            name: "cmi-menu-shrink-height-animation"
            timing:
              duration: 200
              easing: "ease-in"
           ]


      ###
      This is the element intended to be bound as the focus target
      for the `iron-dropdown` contained by `paper-menu-button`.
      ###
      _dropdownContent:
        type: Object

    hostAttributes:
      role: "group"
      "aria-haspopup": "true"

    listeners:
      "iron-select": "_onIronSelect"


    ###
    getter
    ###
    getContentElement: ->
      Polymer.dom(this.$.content).getDistributedNodes()[0]

    ###
    Make the dropdown content appear as an overlay positioned relative
    to the dropdown trigger.
    ###
    open: ->
      return  if @disabled
      @$.dropdown.open()


    ###
    Hide the dropdown content.
    ###
    close: ->
      @$.dropdown.close()


    ###
    When an `iron-select` event is received, the dropdown should
    automatically close on the assumption that a value has been chosen.

    @param {CustomEvent} event A CustomEvent instance with type
    set to `"iron-select"`.
    ###
    _onIronSelect: (event) ->
      @close()  unless @ignoreSelect


    ###
    When the dropdown opens, the `paper-menu-button` fires `paper-open`.
    When the dropdown closes, the `paper-menu-button` fires `paper-close`.

    @param {boolean} opened True if the dropdown is opened, otherwise false.
    @param {boolean} oldOpened The previous value of `opened`.
    ###
    _openedChanged: (opened, oldOpened) ->
      if opened

        # TODO(cdata): Update this when we can measure changes in distributed
        # children in an idiomatic way.
        # We poke this property in case the element has changed. This will
        # cause the focus target for the `iron-dropdown` to be updated as
        # necessary:
        @_dropdownContent = @getContentElement()
        @fire "cmi-dropdown-open"
      else @fire "cmi-dropdown-close"  if oldOpened?


    ###
    If the dropdown is open when disabled becomes true, close the
    dropdown.

    @param {boolean} disabled True if disabled, otherwise false.
    ###
    _disabledChanged: (disabled) ->
      Polymer.IronControlState._disabledChanged.apply this, arguments
      @close()  if disabled and @opened
  )

  CmiMenuButton.ANIMATION_CUBIC_BEZIER = "cubic-bezier(.3,.95,.5,1)"
  CmiMenuButton.MAX_ANIMATION_TIME_MS = 400
  Polymer.CmiMenuButton = CmiMenuButton

)()