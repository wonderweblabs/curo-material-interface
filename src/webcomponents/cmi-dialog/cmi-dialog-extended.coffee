'use strict'

Polymer

  is: 'cmi-dialog-extended'

  behaviors: [
    Polymer.PaperDialogBehavior,
    Polymer.NeonAnimationRunnerBehavior
  ]

  ###
  Fired whenever the cancel button is clicked, ESC is pressed or a click ouside the
  modal happend (depends on noCancelOnOutsideClick and noCancelOnEscKey).
  @event cmi-dialog-extended-cancel
  ###

  ###
  Fired whenever the done button is clicked.
  @event cmi-dialog-extended-done
  ###

  ###
  Fired whenever the success button is clicked.
  @event cmi-dialog-extended-success
  ###

  ###
  Fired whenever a back button is clicked.
  @event cmi-dialog-extended-back
  ###

  ###
  Fired whenever the close button is clicked.
  @event cmi-dialog-extended-close
  ###

  properties:
    sizingTarget:
      type: Object
      value: -> @.$.modalContent
    headline:
      type: String
      value: 'Modal'
    closeBtn:
      type: Boolean
      value: true
    backBtnTop:
      type: Boolean
      value: true
    backBtnBottom:
      type: Boolean
      value: true
    cancelBtn:
      type: String
      value: null
    doneBtn:
      type: String
      value: null
    successBtn:
      type: String
      value: null
    noCancelOnOutsideClick:
      type: Boolean
      value: true

  listeners:
    'neon-animation-finish':  '_onNeonAnimationFinish'

  _renderOpened: ->
    @backdropElement.open() if @withBackdrop

    @playAnimation('entry')

  _renderClosed: ->
    @backdropElement.close() if @withBackdrop

    @playAnimation('exit')

  _onNeonAnimationFinish: ->
    if @opened
      @_finishRenderOpened()
    else
      @_finishRenderClosed()

  _showCancelButton: (cancelBtn) ->
    return false unless cancelBtn?
    cancelBtn != ''

  _showDoneButton: (doneBtn) ->
    return false unless doneBtn?
    doneBtn != ''

  _showSuccessButton: ->
    return false unless successBtn?
    successBtn != ''

  _onClickBtnCancel: ->
    @fire 'cmi-dialog-extended-cancel'

  _onClickBtnDone: ->
    @fire 'cmi-dialog-extended-done'

  _onClickBtnSuccess: ->
    @fire 'cmi-dialog-extended-success'

  _onClickBtnBack: ->
    @fire 'cmi-dialog-extended-back'

  _onClickBtnClose: ->
    @fire 'cmi-dialog-extended-close'

  _onCaptureClick: (event) ->
    return if @noCancelOnOutsideClick == true
    return if @._manager.currentOverlay() != @

    @fire 'cmi-dialog-extended-cancel'

  _onCaptureKeydown: (event) ->
    return if @noCancelOnEscKey == true
    return unless event.keyCode is 27

    event.stopPropagation()
    @fire 'cmi-dialog-extended-cancel'


