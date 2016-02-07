'use strict'

# Polymer
Polymer

  is: 'cmi-textarea'

  properties:
    _ariaLabelledBy:  { type: String, observer: '_ariaLabelledByChanged' }
    _ariaDescribedBy: { type: String, observer: '_ariaDescribedByChanged' }

    ###*
    * The initial number of rows.
    *
    * @attribute rows
    * @type number
    * @default 1
    ###
    rows:             { type: Number, value: 1 }

    ###*
    * The maximum number of rows this element can grow to until it
    * scrolls. 0 means no maximum.
    *
    * @attribute maxRows
    * @type number
    * @default 0
    ###
    maxRows:          { type: Number, value: 0 }

    ###*
    *
    ###
    hintMessage: { type: String, value: null }

  behaviors: [
    Polymer.IronFormElementBehavior,
    Polymer.PaperInputBehavior,
    Polymer.IronControlState
  ]

  _ariaLabelledByChanged: (ariaLabelledBy) ->
    @.$.input.textarea.setAttribute('aria-labelledby', ariaLabelledBy)

  _ariaDescribedByChanged: (ariaDescribedBy) ->
    @.$.input.textarea.setAttribute('aria-describedby', ariaDescribedBy)

