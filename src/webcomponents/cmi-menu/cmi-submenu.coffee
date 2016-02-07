'use strict'

Polymer

  is: 'cmi-submenu'

  properties:

    ###*
    * Set opened to true to show the collapse element and to false to hide it.
    *
    * @attribute opened
    ###
    opened: { type: Boolean, value: false, notify: true, observer: '_openedChanged' }

  behaviors: [
    Polymer.IronControlState
  ]

  ###*
  * Fired when the submenu is opened.
  *
  * @event paper-submenu-open
  ###

  ###*
  * Fired when the submenu is opened.
  *
  * @event cmi-submenu-open
  ###

  ###*
  * Fired when the submenu is closed.
  *
  * @event paper-submenu-close
  ###

  ###*
  * Fired when the submenu is closed.
  *
  * @event cmi-submenu-close
  ###

  getParent: ->
    Polymer.dom(@).parentNode

  getTrigger: ->
    Polymer.dom(@.$.trigger).getDistributedNodes()[0]

  attached: ->
    @listen(@getParent(), 'iron-activate', '_onParentIronActivate')

  dettached: ->
    @unlisten(@getParent(), 'iron-activate', '_onParentIronActivate')

  ###*
  * Expand the submenu content.
  ###
  open: ->
    return if @disabled

    @.$.collapse.show()
    @_active = true
    @getTrigger().classList.add('iron-selected')

  ###*
  * Collapse the submenu content.
  ###
  close: ->
    @.$.collapse.hide()
    @_active = false
    @getTrigger().classList.remove('iron-selected')

  ###*
  * A handler that is called when the trigger is tapped.
  ###
  _onTap: ->
    return if (@disabled)

    @.$.collapse.toggle()

  ###*
  * Toggles the submenu content when the trigger is tapped.
  ###
  _openedChanged: (opened, oldOpened) ->
    if opened
      @fire('paper-submenu-open')
      @fire('cmi-submenu-open')
    else if oldOpened != null
      @fire('paper-submenu-close')
      @fire('cmi-submenu-close')

  ###*
  * A handler that is called when `iron-activate` is fired.
  *
  * @param {CustomEvent} event An `iron-activate` event.
  ###
  _onParentIronActivate: (event) ->
    return if Polymer.Gestures.findOriginalTarget(event) != @getParent()

    # The activated item can either be this submenu, in which case it
    # should be expanded, or any of the other sibling submenus, in which
    # case this submenu should be collapsed.
    if event.detail.item == @
      return if @_active

      @open()
    else
      @close()

  ###*
  * If the dropdown is open when disabled becomes true, close the
  * dropdown.
  *
  * @param {boolean} disabled True if disabled, otherwise false.
  ###
  _disabledChanged: (disabled) ->
    Polymer.IronControlState._disabledChanged.apply(@, arguments)

    @close() if disabled && @_active


