window.CMI or= {}
window.CMI.FormComponents or= {}

class CMI.FormComponents.Textarea

  @animateHeight: (entryPoint, domElement) ->
    # add reference
    entryPoint.append('<div class="cmi-hidden-textarea-reference"></div>')

    # set reference values
    reference = $('.cmi-hidden-textarea-reference', entryPoint)
    reference.css('width', domElement.width())
    reference.html(domElement.val().replace(/\n/g, '<br/>'))

    # set new height
    domElement.css('height', reference.height())

    # clear hidden
    reference.remove()


