(function() {
  'use strict';
  Polymer({
    is: 'cmi-fab',
    behaviors: [Polymer.CmiButtonBehavior],
    properties: {
      block: {
        type: Boolean,
        reflectToAttribute: true,
        value: false
      }
    }
  });

}).call(this);
