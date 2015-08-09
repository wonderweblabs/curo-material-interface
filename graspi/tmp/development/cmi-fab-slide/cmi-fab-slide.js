(function() {
  'use strict';
  Polymer({
    is: 'cmi-fab-slide',
    behaviors: [Polymer.CmiButtonBehavior],
    properties: {
      open: {
        type: Boolean,
        reflectToAttribute: true,
        value: false
      },
      hover: {
        type: Boolean,
        value: false
      }
    },
    ready: function() {
      this.addEventListener('mouseenter', this.onMouseEnter, this);
      return this.addEventListener('mouseleave', this.onMouseLeave, this);
    },
    onMouseEnter: function(event) {
      if (this.hover !== true) {
        return;
      }
      if (this.open === true) {
        return;
      }
      return this.open = true;
    },
    onMouseLeave: function() {
      if (this.hover !== true) {
        return;
      }
      if (this.open === false) {
        return;
      }
      return this.open = false;
    }
  });

}).call(this);
