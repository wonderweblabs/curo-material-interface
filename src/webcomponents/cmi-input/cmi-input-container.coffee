'use strict'

# Polymer
Polymer

  is: 'cmi-input-container'

  properties:

    ###*
    * Set to true to disable the floating label. The label disappears when the input value is
    * not null.
    ###
    noLabelFloat: { type: Boolean, value: false }

    ###*
    * Set to true to always float the floating label.
    ###
    alwaysFloatLabel: { type: Boolean, value: false }

    ###*
    * The attribute to listen for value changes on.
    ###
    attrForValue: { type: String, value: 'bind-value' }

    ###*
    * Set to true to auto-validate the input value when it changes.
    ###
    autoValidate: { type: Boolean, value: false }

    ###*
    * True if the input is invalid. This property is set automatically when the input value
    * changes if auto-validating, or when the `iron-input-validate` event is heard from a child.
    ###
    invalid: { observer: '_invalidChanged', type: Boolean, value: false }

    ###*
    * True if the input has focus.
    ###
    focused: { readOnly: true, type: Boolean, value: false, notify: true }

    _addons: { type: Array }
    # do not set a default value here intentionally - it will be initialized lazily when a
    # distributed child is attached, which may occur before configuration for this element
    # in polyfill.

    _inputHasContent: { type: Boolean, value: false }

    _inputSelector: { type: String, value: 'input,textarea,.paper-input-input' }

    _boundOnFocus:
      type: Function
      value: -> @_onFocus.bind(@)

    _boundOnBlur:
      type: Function
      value: -> @_onBlur.bind(@)

    _boundOnInput:
      type: Function
      value: -> @_onInput.bind(@)

    _boundValueChanged:
      type: Function
      value: -> @_onValueChanged.bind(@)


  listeners:
    'addon-attached':       '_onAddonAttached'
    'iron-input-validate':  '_onIronInputValidate'

  _getValueChangedEvent: ->
    "#{@attrForValue}-changed"

  _getPropertyForValue: ->
    Polymer.CaseMap.dashToCamelCase(@attrForValue)

  _getInputElement: ->
    Polymer.dom(@).querySelector(@_inputSelector)

  _getInputElementValue: ->
    @_getInputElement()[@_getPropertyForValue()] || @_getInputElement().value

  ready: ->
    @_addons or= []

    @addEventListener 'focus', @_boundOnFocus, true
    @addEventListener 'blur', @_boundOnBlur, true

    if @attrForValue
      @_getInputElement().addEventListener(@_getValueChangedEvent(), @_boundValueChanged)
    else
      @addEventListener('input', @_onInput)

  attached: ->
    # Only validate when attached if the input already has a value.
    if @_getInputElementValue() != ''
      @_handleValueAndAutoValidate(@_getInputElement())
    else
      @_handleValue(@_getInputElement())

  _onAddonAttached: (event) ->
    @_addons or= []

    target = event.target

    if @_addons.indexOf(target) == -1
      @_addons.push(target)
      @_handleValue(@_getInputElement()) if @isAttached

  _onFocus: ->
    @_setFocused(true)

  _onBlur: ->
    @_setFocused(false)
    @_handleValueAndAutoValidate(@_getInputElement())

  _onInput: (event) ->
    @_handleValueAndAutoValidate(event.target)

  _onValueChanged: (event) ->
    @_handleValueAndAutoValidate(event.target)

  _handleValue: (inputElement) ->
    value = @_getInputElementValue()

    # type="number" hack needed because @value is empty until it's valid
    if value || value == 0 || (inputElement.type == 'number' && !inputElement.checkValidity())
      @_inputHasContent = true
    else
      @_inputHasContent = false

    @updateAddons
      inputElement: inputElement
      value:        value
      invalid:      @invalid

  _handleValueAndAutoValidate: (inputElement) ->
    if @autoValidate

      if inputElement.validate
        valid = inputElement.validate(@_getInputElementValue())
      else
        valid = inputElement.checkValidity()

      @invalid = !valid

    # Call this last to notify the add-ons.
    @_handleValue(inputElement)

  _onIronInputValidate: (event) ->
    @invalid = @_getInputElement().invalid

  _invalidChanged: ->
    @updateAddons({invalid: @invalid}) if @_addons

  ###*
   * Call this to update the state of add-ons.
   * @param {Object} state Add-on state.
  ###
  updateAddons: (state) ->
    for addon in @_addons
      addon.update(state)

  _computeInputContentClass: (noLabelFloat, alwaysFloatLabel, focused, invalid, _inputHasContent) ->
    cls = 'input-content'

    if !noLabelFloat
      label = @querySelector('label')

      if alwaysFloatLabel || _inputHasContent
        cls += ' label-is-floating'

        # If the label is floating, ignore any offsets that may have been
        # applied from a prefix element.
        @.$.labelAndInputContainer.style.position = 'static'

        if invalid
          cls += ' is-invalid'
        else if (focused)
          cls += " label-is-highlighted"

      else
        # When the label is not floating, it should overlap the input element.
        @.$.labelAndInputContainer.style.position = 'relative' if label

    else
      cls += ' label-is-hidden' if _inputHasContent

    cls

  _computeUnderlineClass: (focused, invalid) ->
    cls = 'underline'

    if invalid
      cls += ' is-invalid'
    else if focused
      cls += ' is-highlighted'

    cls

  _computeAddOnContentClass: (focused, invalid) ->
    cls = 'add-on-content'

    if invalid
      cls += ' is-invalid'
    else if focused
      cls += ' is-highlighted'

    cls
