class CMI.Ripples

  @animateClick: (domElement, event) ->
    @animate(domElement, event.pageX, event.pageY)

  @animate: (domElement, x, y) ->
    # create ink element if doesn't exist
    domElement.prepend('<span class="cmi-ink"></span>') if domElement.find('.cmi-ink').length == 0
    ink = domElement.find('.cmi-ink')

    # stop previous animation
    ink.removeClass('cmi-animate')

    # set size of .ink
    if !ink.height() && !ink.width()
      d = Math.max(domElement.outerWidth(), domElement.outerHeight())
      ink.css({ width: d, height: d })

    # position .ink
    x = x - domElement.offset().left - ink.width()/2
    y = y - domElement.offset().top - ink.height()/2
    ink.css({ top: "#{y}px", left: "#{x}px" })
    ink.addClass('cmi-animate')
