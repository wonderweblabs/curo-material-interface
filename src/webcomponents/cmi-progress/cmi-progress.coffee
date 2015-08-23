'use strict'

# Polymer
Polymer

  is: 'cmi-progress'

  properties:
    secondaryProgress: { type: Number, value: 0, notify: true }
    secondaryRatio: { type: Number, value: 0, readOnly: true, observer: '_secondaryRatioChanged' }
    indeterminate: { type: Boolean, value: false, notify: true, observer: '_toggleIndeterminate' }

  behaviors: [
    Polymer.IronRangeBehavior
  ]

  observers: [
    '_ratioChanged(ratio)',
    '_secondaryProgressChanged(secondaryProgress, min, max)'
  ]

  _toggleIndeterminate: ->
    @toggleClass('indeterminate', @indeterminate, @.$.activeProgress)
    @toggleClass('indeterminate', @indeterminate, @.$.indeterminateSplitter)

  _transformProgress: (progress, ratio) ->
    transform = 'scaleX(' + (ratio / 100) + ')'
    progress.style.transform = progress.style.webkitTransform = transform

  _ratioChanged: (ratio) ->
    @_transformProgress(@.$.activeProgress, ratio)

  _secondaryRatioChanged: (secondaryRatio) ->
    @_transformProgress(@.$.secondaryProgress, secondaryRatio)

  _secondaryProgressChanged: ->
    @secondaryProgress = @_clampValue(@secondaryProgress)
    @_setSecondaryRatio(@_calcRatio(@secondaryProgress) * 100)
