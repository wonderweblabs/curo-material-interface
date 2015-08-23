'use strict'

# Polymer
Polymer

  is: 'cmi-table'

  extends: 'table'

  properties:
    striped: { type: Boolean, reflectToAttribute: true, value: true }
    hoverable: { type: Boolean, reflectToAttribute: true, value: true }

  behaviors: []