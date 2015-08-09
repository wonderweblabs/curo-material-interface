(function() {
  'use strict';
  Polymer.CmiButtonBehaviorImpl = {
    properties: {
      filled: {
        type: Boolean,
        reflectToAttribute: true,
        value: false
      },
      small: {
        type: Boolean,
        reflectToAttribute: true,
        value: false
      },
      large: {
        type: Boolean,
        reflectToAttribute: true,
        value: false
      },
      block: {
        type: Boolean,
        reflectToAttribute: true,
        value: false
      },
      theme: {
        type: String,
        reflectToAttribute: true,
        value: 'default'
      },
      href: {
        type: String,
        reflectToAttribute: true,
        value: null
      },
      target: {
        type: String,
        reflectToAttribute: true,
        value: '_self'
      },
      title: {
        type: String,
        reflectToAttribute: true,
        value: null
      },
      raised: {
        type: Boolean,
        reflectToAttribute: true,
        value: false,
        observer: '_calculateElevation'
      }
    },
    _upHandler: function() {
      this._openLink();
      return Polymer.IronButtonStateImpl._upHandler.apply(this);
    },
    _asyncClick: function() {
      this._openLink();
      return Polymer.IronButtonStateImpl._asyncClick.apply(this);
    },
    _openLink: function() {
      var target;
      if (!(this.href !== null && this.href !== void 0)) {
        return;
      }
      target = this.target;
      target || (target = '_self');
      this._setFocused(false);
      this._setPointerDown(false);
      this._setPressed(false);
      return window.open(this.href, target);
    },
    _calculateElevation: function() {
      if (this.raised) {
        return Polymer.PaperButtonBehaviorImpl._calculateElevation.apply(this);
      } else if (this.active || this.pressed) {
        return this._elevation = 1;
      } else {
        return this._elevation = 0;
      }
    },
    _computeContentClass: function(receivedFocusFromKeyboard) {
      var classes;
      classes = [];
      classes.push('content');
      classes.push('cmi-button');
      if (receivedFocusFromKeyboard) {
        classes.push('keyboard-focus');
      }
      return classes.join(' ');
    }
  };

  Polymer.CmiButtonBehavior = [Polymer.PaperButtonBehavior, Polymer.CmiButtonBehaviorImpl];

  Polymer({
    is: 'cmi-button-behavior'
  });

}).call(this);
