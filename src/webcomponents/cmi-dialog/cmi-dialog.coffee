'use strict'

# Polymer
Polymer

  is: 'cmi-dialog'

  behaviors: [
    Polymer.PaperDialogBehavior,
    Polymer.NeonAnimationRunnerBehavior
  ]

  listeners:
    'neon-animation-finish': '_onNeonAnimationFinish'

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

