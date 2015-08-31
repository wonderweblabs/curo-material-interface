'use strict'

Polymer

  is: 'cmi-submenu'

  properties:
    opened: { type: Boolean, value: false, notify: true, observer: '_openedChanged' }

  behaviors: [
    Polymer.IronControlState
  ]

  getParent: ->
    Polymer.dom(@).parentNode

  getTrigger: ->
    Polymer.dom(@.$.trigger).getDistributedNodes()[0]

  attached: ->
    @listen(@getParent(), 'iron-activate', '_onParentIronActivate')

  dettached: ->
    @unlisten(@getParent(), 'iron-activate', '_onParentIronActivate')

  open: ->
    return if (@disabled)

    @.$.collapse.show()
    @_active = true
    @getTrigger().classList.add('iron-selected')

  close: ->
    @.$.collapse.hide()
    @_active = false
    @getTrigger().classList.remove('iron-selected')

  _onTap: ->
    return if (@disabled)

    @.$.collapse.toggle()

  _openedChanged: (opened, oldOpened) ->
    if opened
      @fire('paper-submenu-open')
    else if oldOpened != null
      @fire('paper-submenu-close')

  _onParentIronActivate: (event) ->
    return if Polymer.Gestures.findOriginalTarget(event) != @getParent()

    if event.detail.item == @
      return if @_active

      @open()
    else
      @close()

  _disabledChanged: (disabled) ->
    Polymer.IronControlState._disabledChanged.apply(@, arguments)

    @close() if disabled && @_active


