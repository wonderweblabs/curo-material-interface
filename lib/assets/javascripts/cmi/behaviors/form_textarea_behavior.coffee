window.CMI or= {}

class CMI.FormTextareaBehavior extends Marionette.Behavior

  behaviors:
    CMITextFields:
      behaviorClass: CMI.FormTextFieldBehavior

  ui:
    textareas: '.cmi-text-input textarea'

  events:
    'keyup @ui.textareas': 'onKeyUp'
    'keydown @ui.textareas': 'onKeyDown'

  onRender: ->
    reference = @.$el

    @ui.textareas.each ->
      CMI.FormComponents.Textarea.animateHeight reference, $(this)

  onKeyUp: (event) ->
    target = $(event.currentTarget)
    CMI.FormComponents.Textarea.animateHeight @.$el, target

  onKeyDown: (event) ->
    target = $(event.currentTarget)
    CMI.FormComponents.Textarea.animateHeight @.$el, target


  #
  # If you outside implementation works with hiding elements that
  # contain textareas, the textareas won't be resized after showing
  # those elements since the calculation fails.
  #
  # To fix this, call triggerMethod('cmi:form:textarea:refresh') on
  # the view implementing the textarea behavior to resize correctly.
  #
  onCmiFormTextareaRefresh: ->
    @onRender()
