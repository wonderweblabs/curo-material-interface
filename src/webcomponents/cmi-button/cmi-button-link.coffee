'use strict'

Polymer

  is: 'cmi-button-link'

  extends: 'a'

  ready: ->
    cmiButton = Polymer.dom(this.root).querySelector('cmi-button')

    for namedItem in (@.attributes || [])
      if namedItem.name != 'is'
        cmiButton.setAttributeNode(namedItem.cloneNode(true))
