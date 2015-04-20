window.CMI or= {}

class CMI.Tabs

  @activate: (domElement) ->
    domElement = $(domElement) unless domElement instanceof jQuery
    return if domElement? == false || domElement.length <= 0

    # load tabs
    tabs = domElement.parents('.cmi-tabs')
    @_ensureActiveIndicator(tabs)
    indicator = tabs.find('.cmi-tabs-active-indicator')

    # new position
    position = domElement.offsetParent().position()
    left = position.left
    right = tabs.innerWidth() - left - domElement.outerWidth()

    # moving direction
    indicator.removeClass('cmi-tabs-animate-right').removeClass('cmi-tabs-animate-left')
    if left < indicator.position().left
      indicator.addClass('cmi-tabs-animate-left')
    else
      indicator.addClass('cmi-tabs-animate-right')

    # animate indicator
    indicator.css({ left: "#{left}px", right: "#{right}px" })

    # set link active
    tabs.find('li').removeClass('cmi-tabs-active')
    domElement.parents('li').addClass('cmi-tabs-active')

    # switch tab
    tabsContainer = $(tabs.data('cmi-tabs-container'))
    element = document.getElementById(domElement.attr('href').replace('#', ''))
    if element? == true && element.className.indexOf('cmi-tabs-active') < 0
      tabsContainer.find('.cmi-tabs-tab').removeClass('cmi-tabs-active')
      element.className += ' cmi-tabs-active'


  # ---------------------------------------------
  # private

  @_ensureActiveIndicator: (tabsElement) ->
    return if tabsElement.find('.cmi-tabs-active-indicator').length > 0
    tabsElement.append('<li class="cmi-tabs-active-indicator"></li>')
