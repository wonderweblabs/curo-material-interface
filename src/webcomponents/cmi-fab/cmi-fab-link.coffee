'use strict'

# Polymer
Polymer

  is: 'cmi-fab-link'

  extends: 'a'

  ready: ->
    cmiButton = Polymer.dom(this.root).querySelector('cmi-fab')

    for namedItem in (@.attributes || [])
      if namedItem.name != 'is'
        cmiButton.setAttributeNode(namedItem.cloneNode(true))
