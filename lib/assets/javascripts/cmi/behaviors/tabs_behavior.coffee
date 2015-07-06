#= require lib/jquery.cookie

window.CMI or= {}

#
# Will triggers method "onCmiTabsClick: (target)" on
# the view if method is defined.
#
# Attention: It does not automatically mean, there is a
#            new tab visible. It just triggers on navbar
#            tab click.
#
class CMI.TabsBehavior extends Marionette.Behavior

  ui:
    tabs: '.cmi-tabs > li > a'
    tabActive: '.cmi-tabs > li.cmi-tabs-active > a' # fixed here li identifier
    tabsNavigation: '.cmi-tabs'

  events:
    'click @ui.tabs': 'onTabClick'

  onRender: ->
    @onCmiTabsRefresh()

  onShow: ->
    @loadCookie()
    @activate(@ui.tabActive)

  onCmiTabsRefresh: ->
    @view.bindUIElements()
    @loadCookie()
    @ui.tabActive.click()

  onTabClick: (event, b) ->
    event.preventDefault()
    target = $(event.currentTarget)

    @activate(target)
    @view.triggerMethod 'cmi:tabs:click', target

    @setCookie(target)

  getTabsName: ->
    @ui.tabsNavigation.data('cmi-tabs-name')

  getCurrentTab: ->
    $("[data-cmi-tabs-name=#{@getTabsName()}].cmi-tabs-tab.cmi-tabs-active")

  getTabForNavigationElement: (domElement) ->
    id = domElement.data('cmi-tab-id').replace('#', '')

    $("[data-cmi-tabs-name=#{@getTabsName()}]##{id}.cmi-tabs-tab")

  loadCookie: ->
    if @ui.tabsNavigation?
      for tab in @ui.tabsNavigation
        value = $.cookie($(tab).data('cmi-tabs-name'))

        @ui.tabActive = $("a[data-cmi-tab-id='#{value}']")

  setCookie: (target) ->
    if @ui.tabsNavigation?
      for tab in @ui.tabsNavigation
        key = $(tab).data('cmi-tabs-name')
        value = target.data('cmi-tab-id')

        $.cookie(key, value)

  activate: (domElement) ->
    return unless domElement instanceof jQuery
    return unless domElement.length > 0
    return if domElement == @getCurrentTab()

    currentDomElement = @getCurrentTab()
    unless currentDomElement instanceof jQuery && currentDomElement.length > 0
      currentDomElement = null

    @view.triggerMethod 'cmi:tabs:tab:beforeShow', @getTabForNavigationElement(domElement)
    @view.triggerMethod 'cmi:tabs:tab:beforeHide', currentDomElement if currentDomElement? == true

    CMI.Tabs.activate(domElement)

    @view.triggerMethod 'cmi:tabs:tab:hide', currentDomElement if currentDomElement? == true
    @view.triggerMethod 'cmi:tabs:tab:show', @getTabForNavigationElement(domElement)
