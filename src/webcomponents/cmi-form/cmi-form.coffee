'use strict'

Polymer

  is: 'cmi-form'

  extends: 'form'

  properties:

    ###*
    * Content type to use when sending data. If the `contentType` property
    * is set and a `Content-Type` header is specified in the `headers`
    * property, the `headers` property value will take precedence.
    * If Content-Type is set to a value listed below, then
    * the `body` (typically used with POST requests) will be encoded accordingly.
    *
    *    * `content-type="application/json"`
    *      * body is encoded like `{"foo":"bar baz","x":1}`
    *    * `content-type="application/x-www-form-urlencoded"`
    *      * body is encoded like `foo=bar+baz&x=1`
    ###
    contentType: { type: String, value: "application/x-www-form-urlencoded" }

    ###*
    * By default, the form will display the browser's native validation
    * UI (i.e. popup bubbles and invalid styles on invalid fields). You can
    * manually disable this; however, if you do, note that you will have to
    * manually style invalid *native* HTML fields yourself, as you are
    * explicitly preventing the native form from doing so.
    ###
    disableNativeValidationUi: { type: Boolean, value: false }

    ###*
    * Set the withCredentials flag when sending data.
    ###
    withCredentials: { type: Boolean, value: false }

    ###*
    * HTTP request headers to send.
    *
    * Note: setting a `Content-Type` header here will override the value
    * specified by the `contentType` property of this element.
    ###
    headers:
      type: Object
      value: -> {}

    ###*
    * iron-ajax request object used to submit the form.
    ###
    request: { type: Object }

  ###*
  * Fired if the form cannot be submitted because it's invalid.
  *
  * @event iron-form-invalid
  ###

  ###*
  * Fired if the form cannot be submitted because it's invalid.
  *
  * @event cmi-form-invalid
  ###

  ###*
  * Fired before the form is submitted.
  *
  * @event iron-form-presubmit
  ###

  ###*
  * Fired before the form is submitted.
  *
  * @event cmi-form-presubmit
  ###

  ###*
  * Fired after the form is submitted.
  *
  * @event iron-form-submit
  ###

  ###*
  * Fired after the form is submitted.
  *
  * @event cmi-form-submit
  ###

  ###*
  * Fired after the form is reset.
  *
  * @event iron-form-reset
  ###

  ###*
  * Fired after the form is reset.
  *
  * @event cmi-form-reset
  ###

  ###*
  * Fired after the form is submitted and a response is received. An
  * IronRequestElement is included as the event.detail object.
  *
  * @event iron-form-response
  ###

  ###*
  * Fired after the form is submitted and a response is received. An
  * IronRequestElement is included as the event.detail object.
  *
  * @event cmi-form-response
  ###

  ###*
  * Fired after the form is submitted and an error is received. An
  * IronRequestElement is included as the event.detail object.
  *
  * @event iron-form-error
  ###

  ###*
  * Fired after the form is submitted and an error is received. An
  * IronRequestElement is included as the event.detail object.
  *
  * @event cmi-form-error
  ###

  listeners:
    'iron-form-element-register':   '_registerElement'
    'iron-form-element-unregister': '_unregisterElement'
    'cmi-form-element-register':    '_registerElement'
    'cmi-form-element-unregister':  '_unregisterElement'
    'submit':                       '_onSubmit'
    'reset':                        '_onReset'

  ready: ->
    @_requestBot = document.createElement('iron-ajax')
    @_requestBot.addEventListener('response', @_handleFormResponse.bind(@))
    @_requestBot.addEventListener('error', @_handleFormError.bind(@))

    @_customElements              = []
    @_customElementsInitialValues = []

  ###*
  * Submits the form
  ###
  submit: ->
    if !@noValidate && !@validate()
      @_doFakeSubmitForValidation() if !@disableNativeValidationUi
      @fire('iron-form-invalid')
      @fire('cmi-form-invalid')
      return

    json = @serialize()

    # Native forms can also index elements magically by their name (can't make
    # this up if I tried) so we need to get the correct attributes, not the
    # elements with those names.
    @request.url              = @getAttribute('action')
    @request.method           = @getAttribute('method')
    @request.contentType      = @contentType
    @request.withCredentials  = @withCredentials
    @request.headers          = @headers

    if @method.toUpperCase() == 'POST'
      @request.body = json
    else
      @request.params = json

    # Allow for a presubmit hook
    event = @fire('iron-form-presubmit', {}, { cancelable: true })
    event = @fire('cmi-form-presubmit', {}, { cancelable: true })

    if !event.defaultPrevented
      @request.generateRequest()
      @fire('iron-form-submit', json)

  ###*
  * Handler that is called when the native form fires a `submit` event
  *
  * @param {Event} event A `submit` event.
  ###
  _onSubmit: (event) ->
    @submit()

    event.preventDefault() if event

    return false

  ###*
  * Handler that is called when the native form fires a `reset` event
  *
  * @param {Event} event A `reset` event.
  ###
  _onReset: (event) ->
    @_resetCustomElements()

  ###*
  * Returns a json object containing name/value pairs for all the registered
  * custom components and native elements of the form. If there are elements
  * with duplicate names, then their values will get aggregated into an
  * array of values.
  *
  * @return {!Object}
  ###
  serialize: ->
    json = {}

    addSerializedElement = (name, value) =>
      # If the name doesn't exist, add it. Otherwise, serialize it to
      # an array,
      if !json[name]
        json[name] = value
      else
        json[name] = [json[name]] if !Array.isArray(json[name])
        json[name].push(value)

    # Go through all of the registered custom components.
    for el in @_customElements
      addSerializedElement(el.name, el.value) if @_useValue(el)

    # Also go through the form's native elements.
    for el in @elements
      # Checkboxes and radio buttons should only use their value if they're checked.
      # Also, custom elements that extend native elements (like an
      # `<input is="fancy-input">`) will appear in both lists. Since they
      # were already added as a custom element, they don't need
      # to be re-added.
      continue if !@_useValue(el) || (el.hasAttribute('is') && json[el.name])

      if el.tagName.toLowerCase() == 'select' && el.multiple
        # A <select multiple> has an array of values.
        for option in el.options
          addSerializedElement(el.name, option.value) if option.selected

      else
        addSerializedElement(el.name, el.value)

    return json

  _handleFormResponse: (event) ->
    @fire('iron-form-response', event.detail)
    @fire('cmi-form-response', event.detail)

  _handleFormError: (event) ->
    @fire('iron-form-error', event.detail)
    @fire('cmi-form-error', event.detail)

  _registerElement: (e) ->
    element = e.target
    element._parentForm = @
    @_customElements.push(element)

    # Save the original value of this input.
    if @_usesCheckedInsteadOfValue(element)
      @_customElementsInitialValues.push(element.checked)
    else
      @_customElementsInitialValues.push(element.value)

  _unregisterElement: (e) ->
    target = e.detail.target

    if target
      index = @_customElements.indexOf(target)

      if index > -1
        @_customElements.splice(index, 1)
        @_customElementsInitialValues.splice(index, 1)

  ###*
  * Validates all the required elements (custom and native) in the form.
  * @return {boolean} True if all the elements are valid.
  ###
  validate: ->
    valid = true

    # Validate all the custom elements.
    for el in @_customElements
      if el.required && !el.disabled
        validatable = (el) # @type {{validate: (function() : boolean)}}

        # Some elements may not have correctly defined a validate method.
        valid = !!validatable.validate() && valid if validatable.validate

    # Validate the form's native elements.
    for el in @elements
      # Custom elements that extend a native element will also appear in
      # this list, but they've already been validated.
      if !el.hasAttribute('is') && el.willValidate && el.checkValidity
        valid = el.checkValidity() && valid

    return valid

  ###*
  * Returns whether the given element is a radio-button or a checkbox.
  * @return {boolean} True if the element has a `checked` property.
  ###
  _usesCheckedInsteadOfValue: (el) ->
    return true if el.type == 'checkbox' || el.type == 'radio'
    return true if el.getAttribute('role') == 'checkbox'
    return true if el.getAttribute('role') == 'radio'
    return true if el['_hasIronCheckedElementBehavior']

    return false

  _useValue: (el) ->
    # Skip disabled elements or elements that don't have a `name` attribute.
    return false if el.disabled || !el.name

    # Checkboxes and radio buttons should only use their value if they're
    # checked. Custom paper-checkbox and paper-radio-button elements
    # don't have a type, but they have the correct role set.
    if @_usesCheckedInsteadOfValue(el)
      if el.boolean == true
        return true
      else
        return el.checked

    return true

  _doFakeSubmitForValidation: ->
    fakeSubmit = document.createElement('input')
    fakeSubmit.setAttribute('type', 'submit')
    fakeSubmit.style.display = 'none'
    @appendChild(fakeSubmit)

    fakeSubmit.click()

    @removeChild(fakeSubmit)

  ###*
  * Resets all non-disabled form custom elements to their initial values.
  ###
  _resetCustomElements: () ->
    # Reset all the registered custom components. We need to do this after
    # the native reset, since programmatically changing the `value` of some
    # native elements (iron-input in particular) does not notify its
    # parent `paper-input`, which will now display the wrong value.
    @this.async ->
      for el, i in @_customElements
        continue if el.disabled

        if @_usesCheckedInsteadOfValue(el)
          el.checked = @_customElementsInitialValues[i]
        else
          el.value = @_customElementsInitialValues[i]

        el.invalid = false

      @fire('iron-form-reset')
      @fire('cmi-form-reset')
    , 1



