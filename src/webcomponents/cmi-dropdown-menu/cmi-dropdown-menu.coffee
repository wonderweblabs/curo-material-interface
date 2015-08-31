'use strict'

Polymer

  is: "cmi-dropdown-menu"

  ###
  Fired when the dropdown opens.

  @event paper-dropdown-open
  ###

  ###
  Fired when the dropdown closes.

  @event paper-dropdown-close
  ###
  behaviors: [
    Polymer.IronControlState,
    Polymer.IronButtonState
  ]

  properties:

    ###
    The derived "label" of the currently selected item. This value
    is the `label` property on the selected item if set, or else the
    trimmed text content of the selected item.
    ###
    selectedItemLabel:
      type: String
      notify: true
      computed: "_computeSelectedItemLabel(selectedItem)"


    ###
    The last selected item. An item is selected if the dropdown menu has
    a child with class `dropdown-content`, and that child triggers an
    `iron-select` event with the selected `item` in the `detail`.
    ###
    selectedItem:
      type: Object
      notify: true
      readOnly: true


    ###
    The label for the dropdown.
    ###
    label:
      type: String


    ###
    The placeholder for the dropdown.
    ###
    placeholder:
      type: String


    ###
    True if the dropdown is open. Otherwise, false.
    ###
    opened:
      type: Boolean
      notify: true
      value: false


    ###
    Set to true to disable the floating label. Bind this to the
    `<paper-input-container>`'s `noLabelFloat` property.
    ###
    noLabelFloat:
      type: Boolean
      value: false
      reflectToAttribute: true


    ###
    Set to true to always float the label. Bind this to the
    `<paper-input-container>`'s `alwaysFloatLabel` property.
    ###
    alwaysFloatLabel:
      type: Boolean
      value: false


    ###
    Set to true to disable animations when opening and closing the
    dropdown.
    ###
    noAnimations:
      type: Boolean
      value: false

  listeners:
    tap: "_onTap"

  keyBindings:
    "up down": "open"
    esc: "close"

  hostAttributes:
    role: "group"
    "aria-haspopup": "true"

  attached: ->

    # NOTE(cdata): Due to timing, a preselected value in a `IronSelectable`
    # child will cause an `iron-select` event to fire while the element is
    # still in a `DocumentFragment`. This has the effect of causing
    # handlers not to fire. So, we double check this value on attached:
    contentElement = @getContentElement()
    @_setSelectedItem contentElement.selectedItem  if contentElement and contentElement.selectedItem

  ###
  getter
  ###
  getContentElement: ->
    Polymer.dom(this.$.content).getDistributedNodes()[0]

  ###
  Show the dropdown content.
  ###
  open: ->
    @$.menuButton.open()


  ###
  Hide the dropdown content.
  ###
  close: ->
    @$.menuButton.close()


  ###
  A handler that is called when `iron-select` is fired.

  @param {CustomEvent} event An `iron-select` event.
  ###
  _onIronSelect: (event) ->
    @_setSelectedItem event.detail.item
    @fire 'cmi-dropdown-menu-select'


  ###
  A handler that is called when the dropdown is tapped.

  @param {CustomEvent} event A tap event.
  ###
  _onTap: (event) ->
    @open()  if Polymer.Gestures.findOriginalTarget(event) is this


  ###
  Compute the label for the dropdown given a selected item.

  @param {Element} selectedItem A selected Element item, with an
  optional `label` property.
  ###
  _computeSelectedItemLabel: (selectedItem) ->
    return ""  unless selectedItem
    selectedItem.label or selectedItem.textContent.trim()


  ###
  Compute the vertical offset of the menu based on the value of
  `noLabelFloat`.

  @param {boolean} noLabelFloat True if the label should not float
  above the input, otherwise false.
  ###
  _computeMenuVerticalOffset: (noLabelFloat) ->

    # NOTE(cdata): These numbers are somewhat magical because they are
    # derived from the metrics of elements internal to `paper-input`'s
    # template. The metrics will change depending on whether or not the
    # input has a floating label.
    (if noLabelFloat then -4 else 16)



