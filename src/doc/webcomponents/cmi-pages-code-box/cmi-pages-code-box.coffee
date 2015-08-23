'use strict'

# Polymer
Polymer

  is: 'cmi-pages-code-box'

  properties:
    contentHtml:  String
    leftCols:     { type: Number, value: 6, notify: true }
    rightCols:    { type: Number, value: 6, notify: true }

  created: ->
    contentHtml = "#{@root.innerHTML}".trim()

    @async =>
      @contentHtml = contentHtml

  _computeLeftColClasses: (cols) ->
    "col-left grid-col-#{cols}"

  _computeRightColClasses: (cols) ->
    "col-right grid-col-#{cols}"