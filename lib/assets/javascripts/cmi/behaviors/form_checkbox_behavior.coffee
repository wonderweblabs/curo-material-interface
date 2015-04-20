window.CMI or= {}

#
# Will triggers method "onCumaCheckboxClick: (targetLabel)" on
# the view if method is defined.
#
class CMI.FormCheckboxBehavior extends Marionette.Behavior

  ui:
    checkboxLabels: '.cmi-checkbox-container label'

  events:
    'click @ui.checkboxLabels': 'onLabelClick'

  onRender: ->
    @ui.checkboxLabels.each ->
      CMI.FormComponents.Checkbox.reset($(this))

  onLabelClick: (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    CMI.FormComponents.Checkbox.click(target)

    @view.triggerMethod('cmi:checkbox:click', target)
