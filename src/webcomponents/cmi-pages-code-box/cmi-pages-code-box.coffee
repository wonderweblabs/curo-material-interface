'use strict'

# Polymer
Polymer

  is: 'cmi-pages-code-box'

  properties:
    contentHtml: String

  created: ->
    contentHtml = "#{@root.innerHTML}".trim()

    @async =>
      @contentHtml = contentHtml

