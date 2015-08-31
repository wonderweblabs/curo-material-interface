'use strict'

Polymer.CmiMenuBehaviorImpl =

  properties:
    valueName:
      type: String
      notify: true
      value: 'value'
      observer: '_onMenuBehaviorValueNameChange'
    titleName:
      type: String
      notify: true
      value: 'title'
      observer: '_onMenuBehaviorTitleNameChange'
    menuItems:
      type: Array
      notify: true
      value: => []

  hostAttributes:
    role: 'group'

  listeners:
    'iron-activate': '_onMenuBehaviorIronActivate'

  attached: ->
    @async => @.$['menu-content']._updateSelected()

  _onMenuBehaviorIronActivate: ->
    @fire 'cmi-menu-behavior-select'

  _onMenuBehaviorValueNameChange: ->
    @attrForSelected = @valueName

  _onMenuBehaviorTitleNameChange: ->
    @attrForItemTitle = @titleName

  _computeIfItemsRepeat: (menuItems) ->
    (menuItems || []).length > 0

  _computeItems: (attrForSelected, attrForItemTitle, menuItems) ->
    result = []

    for item in (menuItems || [])
      continue if item instanceof Array

      if item instanceof Object && !(item instanceof Array)
        value = item[@valueName]
        title = item[@titleName]
      else
        value = item
        title = item

      obj = {}
      obj[@valueName] = value || ''
      obj[@titleName] = title || ''
      result.push obj

    @fire 'cmi-menu-behavior-items-change'
    result


# Polymer
Polymer.CmiMenuBehavior = [
  Polymer.IronMenuBehavior,
  Polymer.CmiMenuBehaviorImpl
]