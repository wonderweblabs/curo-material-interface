'use strict'

# Polymer
Polymer

  is: 'cmi-textarea'

  properties:
    _ariaLabelledBy:  { type: String, observer: '_ariaLabelledByChanged' }
    _ariaDescribedBy: { type: String, observer: '_ariaDescribedByChanged' }
    rows:             { type: Number, value: 1 }
    maxRows:          { type: Number, value: 0 }

  behaviors: [
    Polymer.PaperInputBehavior,
    Polymer.CmiInputBehavior
  ]

  _ariaLabelledByChanged: (ariaLabelledBy) ->
    @.$.input.textarea.setAttribute('aria-labelledby', ariaLabelledBy)

  _ariaDescribedByChanged: (ariaDescribedBy) ->
    @.$.input.textarea.setAttribute('aria-describedby', ariaDescribedBy)
