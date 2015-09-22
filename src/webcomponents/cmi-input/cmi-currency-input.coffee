'use valueict'

# Polymer
Polymer

  is: 'cmi-currency-input'

  behaviors: [
    Polymer.PaperInputBehavior,
    Polymer.IronFormElementBehavior
  ]

  properties:
    label:
      type: String
      value: 'Preis in €'
    value:
      observer: '_onValueChanged'

  observers: [
    '_onFocusedChanged(focused)'
  ]

  ready: ->
    # If there's an initial input, validate it.
    if (@value)
      formattedValue = @_format(@value)
      @updateValueAndPreserveCaret(formattedValue)
      @_handleAutoValidate()

  validate: ->
    # Update the container and its addons (i.e. the custom error-message).
    valid = @$.input.validate()
    @$.container.invalid = !valid
    @$.container.updateAddons(
      inputElement: @$.input,
      value: @value,
      invalid: !valid
    )

    valid

  _onValueChanged: (value, oldValue) ->
    # The initial property assignment is handled by `ready`.
    return if oldValue == undefined

    formattedValue = @_format(value)
    @updateValueAndPreserveCaret(formattedValue)

    #TODO: set the cursor at the correct position
    #TODO: handle - and + keycode to make the value negative/positive

    @_handleAutoValidate()

  _onFocusedChanged: (focused) ->
    if !focused
      @_handleAutoValidate()

  _format: (value) ->
    value = @_cleanUp(value)
    value = [value.slice(0, -2), value.slice(-2)]

    integerPart = value[0]

    # add a . after each 3. number of the integer part and join it the cents part with a ,
    if integerPart.length > 3
      separatedIntegerPart = []
      times = parseInt((integerPart.length - 1) / 3)

      [times..0].forEach (i) =>
        separatedIntegerPart.push integerPart.slice((-3*(i+1)), integerPart.length + (-3*i))

      value[0] = separatedIntegerPart.join('.')

    value = value.join(',')
    # remove all leading zeros except there is a '0,' at the beginning
    value.replace(/^[0.]+(?!\,|$)/, '')

  _cleanUp: (value)->
    # remove all occurencies of . , - and +
    value = value.replace(/[\.,\-\+]/g, '')

    # prefill with '0`s'
    diff = if value.length > 3 then 0 else 3 - value.length

    prefix = "0".repeat(diff)
    value = "#{prefix}#{value}"
