'use valueict'

# Polymer
Polymer

  is: 'cmi-currency-input'

  behaviors: [
    Polymer.PaperInputBehavior,
    Polymer.IronFormElementBehavior,
    Polymer.IronControlState,
  ]

  properties:
    label:
      type: String
      value: 'Preis in €'
    value:
      observer: '_onValueChanged'
      notify: true,
      type: String
    centValue:
      type: Number
      computed: '_convertToCent(value)'
      reflectToAttribute: true


  _onValueChanged: (newValue, oldValue)->
    formattedValue = @_format(newValue)
    @set('value', formattedValue)

    if @focused
      @inputElement.selectionStart = formattedValue.length
      @inputElement.selectionEnd = formattedValue.length

  _convertToCent: (value)->
    value = "#{value}".replace(".","").replace(',',"")

    if value?
      parseInt(value)
    else
      0

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
    value = "#{value}".replace(/[^0-9]+/g, "")

    # prefill with '0`s'
    diff = if value.length > 3 then 0 else 3 - value.length

    prefix = ''

    while diff > 0
      prefix += "0"
      diff = diff - 1

    value = "#{prefix}#{value}"
