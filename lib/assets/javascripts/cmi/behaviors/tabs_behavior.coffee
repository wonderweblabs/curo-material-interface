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
    tabActive: '.cmi-tabs > li.cmi-active > a'

  events:
    'click @ui.tabs': 'onTabClick'

  onRender: ->
    @activate(@ui.tabActive)

  onShow: ->
    @activate(@ui.tabActive)

  onTabClick: (event, b) ->
    event.preventDefault()
    target = $(event.currentTarget)

    @activate(target)
    @view.triggerMethod 'cmi:tabs:click', target

  activate: (domElement) ->
    CMI.Tabs.activate(domElement)
