window.CMI or= {}

class CMI.RipplesBehavior extends Marionette.Behavior

  ui:
    rippleButton: '.cmi-ripples'

  events:
    'click @ui.rippleButton': 'onRipplesClick'

  onRipplesClick: (event) ->
    CMI.Ripples.animate($(event.currentTarget), event.pageX, event.pageY)