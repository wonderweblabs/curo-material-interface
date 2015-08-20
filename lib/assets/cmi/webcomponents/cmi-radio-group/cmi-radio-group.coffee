'use strict'

# Polymer
Polymer

  is: 'cmi-radio-group'

  behaviors: [
    Polymer.IronA11yKeysBehavior,
    Polymer.IronSelectableBehavior
  ]

  hostAttributes:
    role: 'radiogroup'
    tabindex: 0

  properties:
    attrForSelected:    { type: String, value: 'name' }
    selectedAttribute:  { type: String, value: 'checked' }
    selectable:         { type: String, value: 'cmi-radio-button' }

  keyBindings:
    'left up': 'selectPrevious'
    'right down': 'selectNext'

  select: (value) ->
    if @selected
      oldItem = @_valueToItem(@selected)

      if @selected == value
        oldItem.checked = true
        return

      if oldItem
        oldItem.checked = false

    Polymer.IronSelectableBehavior.select.apply(@, [value])
    @fire 'paper-radio-group-changed'

  selectPrevious: ->
    length = @items.length
    newIndex = Number(@_valueToIndex(@selected))

    loop
      newIndex = (newIndex - 1 + length) % length
      break unless @items[newIndex].disabled

    @select(@_indexToValue(newIndex))

  selectNext: ->
    length = @items.length
    newIndex = Number(@_valueToIndex(@selected))

    loop
      newIndex = (newIndex + 1 + length) % length
      break unless @items[newIndex].disabled

    @select(@_indexToValue(newIndex))

