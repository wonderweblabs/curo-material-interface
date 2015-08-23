'use strict'

# Polymer
Polymer

  is: 'cmi-form'

  extends: 'form'

  properties:
    contentType:
      type: String
      value: "application/x-www-form-urlencoded"
    disableNativeValidationUi:
      type: Boolean
      value: false
    withCredentials:
      type: Boolean
      value: false

  listeners:
    'iron-form-element-register': '_registerElement'
    'iron-form-element-unregister': '_unregisterElement'
    'submit': '_onSubmit'

  ready: ->
    @_requestBot = document.createElement('iron-ajax')
    @_requestBot.addEventListener('response', @_handleFormResponse.bind(@))
    @_requestBot.addEventListener('error', @_handleFormError.bind(@))

    @_customElements = []

  submit: ->
    if !@noValidate && !@validate()
      @_doFakeSubmitForValidation() if !@disableNativeValidationUi
      @fire('iron-form-invalid')
      return

    json = @serialize()

    @_requestBot.url = @action
    @_requestBot.method = @method
    @_requestBot.contentType = @contentType
    @_requestBot.withCredentials = @withCredentials

    if @method.toUpperCase() == 'POST'
      @_requestBot.body = json
    else
      @_requestBot.params = json

    @_requestBot.generateRequest()
    @fire('iron-form-submit', json)

  _onSubmit: (event) ->
    @submit()

    event.preventDefault() if event

    return false

  serialize: ->
    json = {}

    addSerializedElement = (el) =>
      if !json[el.name]
        json[el.name] = el.value
      else
        json[el.name] = [json[el.name]] if !Array.isArray(json[el.name])
        json[el.name].push(el.value)

    for el in @_customElements
      addSerializedElement(el) if @_useValue(el)

    for el in @elements
      continue if !@_useValue(el) || (el.hasAttribute('is') && json[el.name])
      addSerializedElement(el)

    return json

  _handleFormResponse: (event) ->
    @fire('iron-form-response', event.detail.response)

  _handleFormError: (event) ->
    @fire('iron-form-error', event.detail)

  _registerElement: (e) ->
    e.target._parentForm = @
    @_customElements.push(e.target)

  _unregisterElement: (e) ->
    target = e.detail.target

    if target
      index = @_customElements.indexOf(target)

      @_customElements.splice(index, 1) if index > -1

  validate: ->
    valid = true

    for el in @_customElements
      if el.required && @_useValue(el)
        validatable = (el)

        valid = !!validatable.validate() && valid if validatable.validate

    for el in @elements
      if !el.hasAttribute('is') && el.willValidate && el.checkValidity && el.name
        valid = el.checkValidity() && valid

    return valid

  _useValue: (el) ->
    return false if el.disabled || !el.name

    if el.type == 'checkbox' || el.getAttribute('role') == 'checkbox'
      if el.boolean == true
        return true
      else
        return el.checked

    if el.type == 'radio' || el.getAttribute('role') == 'radio'
      return el.checked

    return true

  _doFakeSubmitForValidation: ->
    fakeSubmit = document.createElement('input')
    fakeSubmit.setAttribute('type', 'submit')
    fakeSubmit.style.display = 'none'
    @appendChild(fakeSubmit)

    fakeSubmit.click()

    @removeChild(fakeSubmit)



