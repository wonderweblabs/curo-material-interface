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
