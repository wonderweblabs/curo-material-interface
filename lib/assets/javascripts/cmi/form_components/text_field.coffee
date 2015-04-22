window.CMI or= {}
window.CMI.FormComponents or= {}

class CMI.FormComponents.TextField

  @reset: (domElement) ->
    if domElement.val().length > 0 || domElement.is(':focus')
      domElement.parents(@_getInputBoxSelector()).addClass('cmi-active')
    else
      domElement.parents(@_getInputBoxSelector()).removeClass('cmi-active')

  @animateChange: (domElement) ->
    domElement.parents(@_getInputBoxSelector()).addClass('cmi-active') if domElement.val().length != 0
    @validate_field(domElement, domElement.parents(@_getInputBoxSelector()))

  @animateFocus: (domElement) ->
    domElement.parents(@_getInputBoxSelector()).addClass('cmi-active')

  @animateBlur: (domElement) ->
    domElement.parents(@_getInputBoxSelector()).removeClass('cmi-active') if domElement.val().length == 0
    @validate_field(domElement, domElement.parents(@_getInputBoxSelector()))

  @formReset: (domFormElement) ->
    domElement.parents(@_getInputBoxSelector()).removeClass('cmi-valid').removeClass('cmi-invalid')

    domFormElement.find('select.cmi-initialized').each ->
      reset_text = domFormElement.find('option[selected]').text()
      domFormElement.siblings('input.cmi-select-dropdown').val(reset_text)


  # ---------------------------------------------
  # helper

  @validate_field: (domElement, parentDomElement) ->
    if domElement.val().length == 0
      if parentDomElement.hasClass('cmi-validate')
        parentDomElement.removeClass('cmi-valid')
        parentDomElement.removeClass('cmi-invalid')
    else if parentDomElement.hasClass('cmi-validate')
      if domElement.is(':valid')
        parentDomElement.removeClass('invalid')
        parentDomElement.addClass('cmi-valid')
      else
        parentDomElement.removeClass('cmi-valid')
        parentDomElement.addClass('cmi-invalid')

  @_getInputBoxSelector: ->
    '.cmi-text-input'

