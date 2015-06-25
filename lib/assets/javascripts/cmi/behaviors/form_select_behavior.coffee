window.CMI or= {}

class CMI.FormSelectBehavior extends Marionette.Behavior

  ui:
    selects: '.cmi-select-input'

  onRender: ->
    @ui.selects.each ->
      CMI.FormComponents.Select.reset($(this))

  onShow: ->
    @ui.selects.each ->
      CMI.FormComponents.Select.reset($(this))

  #
  # To trigger a refresh, call triggerMethod('cmi:select:refresh') on
  # the view implementing the behavior.
  #
  onCmiSelectRefresh: ->
    @ui.selects.each ->
      CMI.FormComponents.Select.reset($(this))
