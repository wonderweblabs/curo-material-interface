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
    @onCmiFormTextFieldsReset()

  onInputChange: (event) ->
    CMI.FormComponents.TextField.animateChange($(event.currentTarget))

  onInputFocus: (event) ->
    CMI.FormComponents.TextField.animateFocus($(event.currentTarget))

  onInputBlur: (event) ->
    CMI.FormComponents.TextField.animateBlur($(event.currentTarget))

  onCmiFormTextFieldsReset: ->
    return unless @ui.inputs instanceof jQuery
    return unless @ui.inputs.length > 0

    _self = @

    @ui.inputs.each -> _self.onCmiFormTextFieldReset($(this))

  onCmiFormTextFieldReset: (domElement) ->
    return unless domElement instanceof jQuery

    CMI.FormComponents.TextField.reset(domElement)
    CMI.FormComponents.TextField.animateChange(domElement)
