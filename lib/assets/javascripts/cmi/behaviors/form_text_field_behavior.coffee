window.CMI or= {}

class CMI.FormTextFieldBehavior extends Marionette.Behavior

  @inputSelectors: ->
    '.cmi-text-input input,
    .cmi-text-input textarea'

  ui:
    inputs: "#{@inputSelectors()}"

  events:
    'change @ui.inputs': 'onInputChange'
    'focus @ui.inputs': 'onInputFocus'
    'blur @ui.inputs': 'onInputBlur'

  onRender: ->
    if @ui.inputs? == true && @ui.inputs.length > 0
      @ui.inputs.each ->
        CMI.FormComponents.TextField.reset($(this))

  onInputChange: (event) ->
    CMI.FormComponents.TextField.animateChange($(event.currentTarget))

  onInputFocus: (event) ->
    CMI.FormComponents.TextField.animateFocus($(event.currentTarget))

  onInputBlur: (event) ->
    CMI.FormComponents.TextField.animateBlur($(event.currentTarget))

