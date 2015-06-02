window.CMI or= {}

class CMI.Tabs

  @activate: (invoker) ->
    invoker = $(invoker) unless invoker instanceof jQuery
    return if invoker.length <= 0

    # fetch - links panel
    invokersPanel = invoker.parents('.cmi-tabs').first()
    return if invokersPanel.length <= 0

    # ensure indicator (bar below)
    @_ensureActiveIndicator(invokersPanel)

    # fetch - tabs unique name
    name = invokersPanel.data('cmi-tabs-name')
    return if name? == false || name.length <= 0

    # fetch - upcoming tab
    upcomingTab = @_tabFromInvoker invoker, name
    return if upcomingTab.length <= 0
    return if upcomingTab.hasClass 'cmi-tabs-active'

    # fetch - active tabs
    activeTabs = $("[data-cmi-tabs-name=#{name}].cmi-tabs-tab.cmi-tabs-active")

    # before triggers
    upcomingTab.trigger 'cmi.tabs.beforeShow'
    activeTabs.trigger 'cmi.tabs.beforeHide'

    # set and animate active indicator
    @_setAndAnimateActiveIndicator(invokersPanel, invoker)

    # show / hide
    upcomingTab.addClass 'cmi-tabs-active'
    activeTabs.removeClass 'cmi-tabs-active'
    invokersPanel.find('li').removeClass 'cmi-tabs-active'
    invoker.parents('li').first().addClass 'cmi-tabs-active'

    # after triggers
    upcomingTab.trigger 'cmi.tabs.show'
    activeTabs.trigger 'cmi.tabs.hide'


  # ---------------------------------------------
  # private

  # @nodoc
  @_ensureActiveIndicator: (invokersPanel) ->
    return if invokersPanel.find('.cmi-tabs-active-indicator').length > 0

    invokersPanel.append('<li class="cmi-li cmi-tabs-active-indicator"></li>')

  # @nodoc
  @_tabFromInvoker: (domElement, name) ->
    id = domElement.attr('data-cmi-tab-id').replace('#', '')
    $("[data-cmi-tabs-name=#{name}]##{id}").first()

  # @nodoc
  @_setAndAnimateActiveIndicator: (invokersPanel, invoker) ->
    indicator = invokersPanel.find('.cmi-tabs-active-indicator')

    # new position for active indicator
    position = invoker.offsetParent().position()
    left = position.left
    right = invokersPanel.innerWidth() - left - invoker.outerWidth()

    # moving direction
    indicator.removeClass('cmi-tabs-animate-right').removeClass('cmi-tabs-animate-left')
    if left < indicator.position().left
      indicator.addClass('cmi-tabs-animate-left')
    else
      indicator.addClass('cmi-tabs-animate-right')

    # animate indicator
    indicator.css({ left: "#{left}px", right: "#{right}px" })
