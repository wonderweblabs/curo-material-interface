window.CMI or= {}
window.CMI.FormComponents or= {}

class CMI.FormComponents.Checkbox

  @reset: (domElement) ->
    checkbox = $('input[type="checkbox"]', domElement)
    @_animate(domElement, checkbox.prop('checked'))

  @click: (domElement) ->
    checkbox = $('input[type="checkbox"]', domElement)
    checkbox.prop('checked', !checkbox.prop('checked'))
    @_ripples(domElement)
    @_animate(domElement, checkbox.prop('checked'))


  # ---------------------------------------------
  # private

  @_animate: (domElement, checked) ->
    parent = domElement if domElement.hasClass('.cmi-checkbox')
    parent or= domElement.parents('.cmi-checkbox-container')

    if checked == true
      parent.addClass('cmi-active')
    else
      parent.removeClass('cmi-active')

  @_ripples: (domElement) ->
    parent = domElement if domElement.hasClass('.cmi-checkbox')
    parent or= domElement.parents('.cmi-checkbox-container')

    animation = parent.find('.cmi-animation')
    x = animation.offset().left + animation.outerWidth() / 2
    y = animation.offset().top + animation.outerHeight() / 2
    CMI.Ripples.animate(animation, x, y)