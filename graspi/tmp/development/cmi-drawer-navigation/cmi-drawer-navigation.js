(function() {
  'use strict';
  var classNames, sharedPanel,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  sharedPanel = null;

  classNames = function(obj) {
    var classes, i, key, len, ref;
    classes = [];
    ref = Object.keys(obj);
    for (i = 0, len = ref.length; i < len; i++) {
      key = ref[i];
      if (obj.hasOwnProperty(key) && obj[key]) {
        classes.push(key);
      }
    }
    return classes.join(' ');
  };

  Polymer({
    is: 'cmi-drawer-navigation',
    properties: {
      disableEdgeSwipe: {
        type: Boolean,
        value: false
      },
      disableSwipe: {
        type: Boolean,
        value: false
      },
      dragging: {
        type: Boolean,
        value: false,
        readOnly: true,
        notify: true
      },
      drawerLeftWidth: {
        type: String,
        value: '256px'
      },
      drawerRightWidth: {
        type: String,
        value: '256px'
      },
      edgeSwipeSensitivity: {
        type: Number,
        value: 30
      },
      hasTransform: {
        type: Boolean,
        value: function() {
          return indexOf.call(this.style, 'transform') >= 0;
        }
      },
      hasWillChange: {
        type: Boolean,
        value: function() {
          return indexOf.call(this.style, 'willChange') >= 0;
        }
      },
      peeking: {
        type: Boolean,
        value: false,
        readOnly: true,
        notify: true
      },
      selected: {
        reflectToAttribute: true,
        notify: true,
        type: String,
        value: 'drawer_main'
      },
      drawerLeftToggleAttribute: {
        type: String,
        value: 'cmi-drawer-navigation-toggle-left'
      },
      drawerRightToggleAttribute: {
        type: String,
        value: 'cmi-drawer-navigation-toggle-right'
      },
      transition: {
        type: Boolean,
        value: false
      }
    },
    listeners: {
      tap: '_onTap',
      track: '_onTrack',
      down: '_downHandler',
      up: '_upHandler'
    },
    togglePanel: function(type) {
      if (type == null) {
        type = 'drawer_left';
      }
      if (this.selected === type || type === 'drawer_main') {
        return this.closeDrawer();
      } else {
        return this.openDrawer(type);
      }
    },
    openDrawer: function(type) {
      if (type == null) {
        type = 'drawer_left';
      }
      return this.selected = type;
    },
    closeDrawer: function() {
      return this.selected = 'drawer_main';
    },
    ready: function() {
      return this.transition = true;
    },
    getIronSelectorClasses: function(dragging, transition, peeking, selected) {
      var classes;
      classes = {
        dragging: dragging,
        transition: transition,
        peeking: peeking
      };
      classes[selected.replace('_', '-')] = true;
      return classNames(classes);
    },
    getDrawerStyle: function(type, drawerWidth) {
      if (type == null) {
        type = 'left';
      }
      return "width: " + drawerWidth;
    },
    getMainStyle: function(selected, drawerLeftWidth, drawerRightWidth) {
      var style, transform;
      transform = '0px';
      if (selected === "drawer_left") {
        transform = "" + drawerLeftWidth;
      } else if (selected === "drawer_right") {
        transform = "-" + drawerLeftWidth;
      }
      transform = this._transformForTranslateX(transform).replace('pxpx', 'px');
      style = [];
      style.push("-webkit-transform: " + transform + ";");
      style.push("-moz-transform: " + transform + ";");
      style.push("-ms-transform: " + transform + ";");
      style.push("-o-transform: " + transform + ";");
      style.push("transform: " + transform + ";");
      return style.join('');
    },
    _computeSwipeOverlayHidden: function(disableEdgeSwipe) {
      return disableEdgeSwipe;
    },
    _onTrack: function(event) {
      if (sharedPanel && this !== sharedPanel) {
        return;
      }
      switch (event.detail.state) {
        case 'start':
          return this._trackStart(event);
        case 'track':
          return this._trackX(event);
        case 'end':
          return this._trackEnd(event);
      }
    },
    _swipeAllowed: function() {
      return !this.disableSwipe;
    },
    _isMainSelected: function() {
      return this.selected === 'drawer_main';
    },
    _startEdgePeek: function() {
      var drawer, translate;
      if (event.detail.x > this.offsetWidth / 2) {
        this.width = this.$.drawer_right.offsetWidth;
        drawer = this.$.drawer_right;
        translate = this._translateXForDeltaX(this.edgeSwipeSensitivity * -1, 'right');
      } else {
        this.width = this.$.drawer_left.offsetWidth;
        drawer = this.$.drawer_left;
        translate = this._translateXForDeltaX(this.edgeSwipeSensitivity, 'left');
      }
      this._moveDrawer(translate, drawer);
      return this._setPeeking(true);
    },
    _stopEdgePeek: function() {
      if (this.peeking) {
        this._setPeeking(false);
        return this._moveDrawer(null);
      }
    },
    _downHandler: function(event) {
      if (!this.dragging && this._isMainSelected() && this._isEdgeTouch(event) && !sharedPanel) {
        this._startEdgePeek();
        event.preventDefault();
        return sharedPanel = this;
      }
    },
    _upHandler: function() {
      this._stopEdgePeek();
      return sharedPanel = null;
    },
    _onTap: function(event) {
      var target;
      target = Polymer.dom(event).localTarget;
      if (target && this.drawerLeftToggleAttribute && target.hasAttribute(this.drawerLeftToggleAttribute)) {
        this.togglePanel('drawer_left');
        return;
      }
      if (target && this.drawerRightToggleAttribute && target.hasAttribute(this.drawerRightToggleAttribute)) {
        this.togglePanel('drawer_right');
      }
    },
    _isEdgeTouch: function(event) {
      var x;
      if (this.disableEdgeSwipe) {
        return false;
      }
      if (!this._swipeAllowed()) {
        return false;
      }
      x = event.detail.x;
      if (x > this.offsetWidth / 2) {
        return x >= this.offsetWidth - this.edgeSwipeSensitivity;
      } else {
        return x <= this.edgeSwipeSensitivity;
      }
    },
    _trackStart: function(event) {
      if (!this._swipeAllowed()) {
        return;
      }
      sharedPanel = this;
      this._setDragging(true);
      if (this._isMainSelected()) {
        this._setDragging(this.peeking || this._isEdgeTouch(event));
      }
      if (event.detail.x > this.offsetWidth / 2) {
        this.width = this.$.drawer_right.offsetWidth;
      } else {
        this.width = this.$.drawer_left.offsetWidth;
      }
      return this.transition = false;
    },
    _translateXForDeltaX: function(deltaX, type) {
      var isMain, r;
      if (type == null) {
        type = 'left';
      }
      isMain = this._isMainSelected();
      if (type === 'left') {
        r = Math.min(0, isMain ? deltaX - this.width : deltaX);
      } else {
        r = Math.max(0, isMain ? this.width + deltaX : deltaX);
      }
      return r;
    },
    _trackX: function(event) {
      var dx;
      if (!this.dragging) {
        return;
      }
      dx = event.detail.dx;
      if (this.peeking) {
        if (Math.abs(dx) <= this.edgeSwipeSensitivity) {
          return;
        }
        this._setPeeking(false);
      }
      if (event.detail.x > this.offsetWidth / 2) {
        return this._moveDrawer(this._translateXForDeltaX(dx, 'right'), this.$.drawer_right);
      } else {
        return this._moveDrawer(this._translateXForDeltaX(dx, 'left'), this.$.drawer_left);
      }
    },
    _trackEnd: function(event) {
      var xDirection;
      if (!this.dragging) {
        return;
      }
      this._setDragging(false);
      this.transition = true;
      sharedPanel = null;
      this._moveDrawer(null);
      if (event.detail.x > this.offsetWidth / 2) {
        xDirection = event.detail.dx < 0;
        if (xDirection) {
          return this.openDrawer('drawer_right');
        } else {
          return this.closeDrawer();
        }
      } else {
        xDirection = event.detail.dx > 0;
        if (xDirection) {
          return this.openDrawer('drawer_left');
        } else {
          return this.closeDrawer();
        }
      }
    },
    _transformForTranslateX: function(translateX) {
      if (translateX === null) {
        return '';
      }
      if (this.hasWillChange) {
        return 'translateX(' + translateX + 'px)';
      } else {
        return 'translate3d(' + translateX + 'px, 0, 0)';
      }
    },
    _moveDrawer: function(translateX, drawer) {
      if (drawer == null) {
        drawer = null;
      }
      if (drawer === null) {
        this.transform(this._transformForTranslateX(translateX), this.$.drawer_left);
        this.transform(this._transformForTranslateX(translateX), this.$.drawer_right);
      } else {
        this.transform(this._transformForTranslateX(translateX), drawer);
      }
      if (drawer === this.$.drawer_left) {
        translateX = this.$.drawer_left.offsetWidth + translateX;
        return this.transform(this._transformForTranslateX(translateX), this.$.drawer_main);
      } else if (drawer === this.$.drawer_right) {
        translateX = translateX - this.$.drawer_right.offsetWidth;
        return this.transform(this._transformForTranslateX(translateX), this.$.drawer_main);
      } else {
        return this.transform(this._transformForTranslateX(0), this.$.drawer_main);
      }
    }
  });

}).call(this);
