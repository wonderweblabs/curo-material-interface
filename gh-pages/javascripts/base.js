(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.CMI || (window.CMI = {});

  CMI.LoadingIndicator = (function(superClass) {
    extend(LoadingIndicator, superClass);

    function LoadingIndicator() {
      return LoadingIndicator.__super__.constructor.apply(this, arguments);
    }

    LoadingIndicator.prototype.className = 'cmi-loading-indicator';

    LoadingIndicator.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      this._options = _.extend(this._defaultOptions(), options);
      return this.render();
    };

    LoadingIndicator.prototype.render = function() {
      this.$el.html(this._getInnerHtml());
      if (this._options.background === 'dark') {
        this.$el.addClass('cmi-loading-indicator-background-dark');
      } else if (this._options.background === 'light') {
        this.$el.addClass('cmi-loading-indicator-background-light');
      } else if ((this._options.background != null) === true && this._options.background.length > 0) {
        this.$el.addClass(this._options.background);
      }
      return this;
    };

    LoadingIndicator.prototype.domElement = function() {
      return this.$el;
    };

    LoadingIndicator.prototype.fadeIn = function() {
      if (this._isAttached() === false) {
        this._attach();
      }
      this.$el.addClass('cmi-loading-fade');
      return this;
    };

    LoadingIndicator.prototype.fadeOut = function() {
      this.$el.removeClass('cmi-loading-fade');
      if (this._options.detachAfterFadeOut) {
        _.delay($.proxy(this, '_detach'), 300);
      }
      return this;
    };

    LoadingIndicator.prototype._getInnerHtml = function() {
      return $('<div class="cmi-loading-indicator-inside"> <svg class="circular"> <circle class="path" cx="50" cy="50" fill="none" r="20" stroke-miterlimit="10" stroke-width="3"></circle> </svg> </div>');
    };

    LoadingIndicator.prototype._detach = function() {
      this.$el.detach();
      return this._attached = false;
    };

    LoadingIndicator.prototype._attach = function() {
      if ((this._options.parent != null) === false) {
        return;
      }
      this._options.parent.append(this.$el);
      return this._attached = true;
    };

    LoadingIndicator.prototype._isAttached = function() {
      return this._attached || (this._attached = false);
    };

    LoadingIndicator.prototype._defaultOptions = function() {
      return {
        background: null,
        parent: null,
        detachAfterFadeOut: true
      };
    };

    return LoadingIndicator;

  })(Backbone.View);

}).call(this);
(function() {
  window.CMI || (window.CMI = {});

  CMI.Ripples = (function() {
    function Ripples() {}

    Ripples.animateClick = function(domElement, event) {
      return this.animate(domElement, event.pageX, event.pageY);
    };

    Ripples.animate = function(domElement, x, y) {
      var d, ink;
      if (domElement.find('.cmi-ink').length === 0) {
        domElement.prepend('<span class="cmi-ink"></span>');
      }
      ink = domElement.find('.cmi-ink');
      ink.removeClass('cmi-animate');
      if (!ink.height() && !ink.width()) {
        d = Math.max(domElement.outerWidth(), domElement.outerHeight());
        ink.css({
          width: d,
          height: d
        });
      }
      x = x - domElement.offset().left - ink.width() / 2;
      y = y - domElement.offset().top - ink.height() / 2;
      ink.css({
        top: y + "px",
        left: x + "px"
      });
      return ink.addClass('cmi-animate');
    };

    return Ripples;

  })();

}).call(this);
(function() {
  window.CMI || (window.CMI = {});

  CMI.Tabs = (function() {
    function Tabs() {}

    Tabs.activate = function(domElement) {
      var element, indicator, left, position, right, tabs, tabsContainer;
      if (!(domElement instanceof jQuery)) {
        domElement = $(domElement);
      }
      if ((domElement != null) === false || domElement.length <= 0) {
        return;
      }
      tabs = domElement.parents('.cmi-tabs');
      this._ensureActiveIndicator(tabs);
      indicator = tabs.find('.cmi-tabs-active-indicator');
      position = domElement.offsetParent().position();
      left = position.left;
      right = tabs.innerWidth() - left - domElement.outerWidth();
      indicator.removeClass('cmi-tabs-animate-right').removeClass('cmi-tabs-animate-left');
      if (left < indicator.position().left) {
        indicator.addClass('cmi-tabs-animate-left');
      } else {
        indicator.addClass('cmi-tabs-animate-right');
      }
      indicator.css({
        left: left + "px",
        right: right + "px"
      });
      tabs.find('li').removeClass('cmi-tabs-active');
      domElement.parents('li').addClass('cmi-tabs-active');
      tabsContainer = $(tabs.data('cmi-tabs-container'));
      element = document.getElementById(domElement.attr('href').replace('#', ''));
      if ((element != null) === true && element.className.indexOf('cmi-tabs-active') < 0) {
        tabsContainer.find('.cmi-tabs-tab').removeClass('cmi-tabs-active');
        return element.className += ' cmi-tabs-active';
      }
    };

    Tabs._ensureActiveIndicator = function(tabsElement) {
      if (tabsElement.find('.cmi-tabs-active-indicator').length > 0) {
        return;
      }
      return tabsElement.append('<li class="cmi-tabs-active-indicator"></li>');
    };

    return Tabs;

  })();

}).call(this);
(function() {
  var base;

  window.CMI || (window.CMI = {});

  (base = window.CMI).FormComponents || (base.FormComponents = {});

  CMI.FormComponents.TextField = (function() {
    function TextField() {}

    TextField.reset = function(domElement) {
      if (domElement.val().length > 0) {
        return domElement.parents(this._getInputBoxSelector()).addClass('cmi-active');
      } else {
        return domElement.parents(this._getInputBoxSelector()).removeClass('cmi-active');
      }
    };

    TextField.animateChange = function(domElement) {
      if (domElement.val().length !== 0) {
        domElement.parents(this._getInputBoxSelector()).addClass('cmi-active');
      }
      return this.validate_field(domElement, domElement.parents(this._getInputBoxSelector()));
    };

    TextField.animateFocus = function(domElement) {
      return domElement.parents(this._getInputBoxSelector()).addClass('cmi-active');
    };

    TextField.animateBlur = function(domElement) {
      if (domElement.val().length === 0) {
        domElement.parents(this._getInputBoxSelector()).removeClass('cmi-active');
      }
      return this.validate_field(domElement, domElement.parents(this._getInputBoxSelector()));
    };

    TextField.formReset = function(domFormElement) {
      domElement.parents(this._getInputBoxSelector()).removeClass('cmi-valid').removeClass('cmi-invalid');
      return domFormElement.find('select.cmi-initialized').each(function() {
        var reset_text;
        reset_text = domFormElement.find('option[selected]').text();
        return domFormElement.siblings('input.cmi-select-dropdown').val(reset_text);
      });
    };

    TextField.validate_field = function(domElement, parentDomElement) {
      if (domElement.val().length === 0) {
        if (parentDomElement.hasClass('cmi-validate')) {
          parentDomElement.removeClass('cmi-valid');
          return parentDomElement.removeClass('cmi-invalid');
        }
      } else if (parentDomElement.hasClass('cmi-validate')) {
        if (domElement.is(':valid')) {
          parentDomElement.removeClass('invalid');
          return parentDomElement.addClass('cmi-valid');
        } else {
          parentDomElement.removeClass('cmi-valid');
          return parentDomElement.addClass('cmi-invalid');
        }
      }
    };

    TextField._getInputBoxSelector = function() {
      return '.cmi-text-input';
    };

    return TextField;

  })();

}).call(this);
(function() {
  var base;

  window.CMI || (window.CMI = {});

  (base = window.CMI).FormComponents || (base.FormComponents = {});

  CMI.FormComponents.Textarea = (function() {
    function Textarea() {}

    Textarea.animateHeight = function(entryPoint, domElement) {
      var reference;
      entryPoint.append('<div class="cmi-hidden-textarea-reference"></div>');
      reference = $('.cmi-hidden-textarea-reference', entryPoint);
      reference.css('width', domElement.width());
      reference.html(domElement.val().replace(/\n/g, '<br/>'));
      domElement.css('height', reference.height());
      return reference.remove();
    };

    return Textarea;

  })();

}).call(this);
(function() {
  var base;

  window.CMI || (window.CMI = {});

  (base = window.CMI).FormComponents || (base.FormComponents = {});

  CMI.FormComponents.Checkbox = (function() {
    function Checkbox() {}

    Checkbox.reset = function(domElement) {
      var checkbox;
      checkbox = $('input[type="checkbox"]', domElement);
      return this._animate(domElement, checkbox.prop('checked'));
    };

    Checkbox.click = function(domElement) {
      var checkbox;
      checkbox = $('input[type="checkbox"]', domElement);
      checkbox.prop('checked', !checkbox.prop('checked'));
      this._ripples(domElement);
      return this._animate(domElement, checkbox.prop('checked'));
    };

    Checkbox._animate = function(domElement, checked) {
      var parent;
      if (domElement.hasClass('.cmi-checkbox')) {
        parent = domElement;
      }
      parent || (parent = domElement.parents('.cmi-checkbox-container'));
      if (checked === true) {
        return parent.addClass('cmi-active');
      } else {
        return parent.removeClass('cmi-active');
      }
    };

    Checkbox._ripples = function(domElement) {
      var animation, parent, x, y;
      if (domElement.hasClass('.cmi-checkbox')) {
        parent = domElement;
      }
      parent || (parent = domElement.parents('.cmi-checkbox-container'));
      animation = parent.find('.cmi-animation');
      x = animation.offset().left + animation.outerWidth() / 2;
      y = animation.offset().top + animation.outerHeight() / 2;
      return CMI.Ripples.animate(animation, x, y);
    };

    return Checkbox;

  })();

}).call(this);
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.CMI || (window.CMI = {});

  CMI.RipplesBehavior = (function(superClass) {
    extend(RipplesBehavior, superClass);

    function RipplesBehavior() {
      return RipplesBehavior.__super__.constructor.apply(this, arguments);
    }

    RipplesBehavior.prototype.ui = {
      rippleButton: '.cmi-ripples'
    };

    RipplesBehavior.prototype.events = {
      'click @ui.rippleButton': 'onRipplesClick'
    };

    RipplesBehavior.prototype.onRipplesClick = function(event) {
      return CMI.Ripples.animate($(event.currentTarget), event.pageX, event.pageY);
    };

    return RipplesBehavior;

  })(Marionette.Behavior);

}).call(this);
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.CMI || (window.CMI = {});

  CMI.TabsBehavior = (function(superClass) {
    extend(TabsBehavior, superClass);

    function TabsBehavior() {
      return TabsBehavior.__super__.constructor.apply(this, arguments);
    }

    TabsBehavior.prototype.ui = {
      tabs: '.cmi-tabs > li > a',
      tabActive: '.cmi-tabs > li.cmi-active > a'
    };

    TabsBehavior.prototype.events = {
      'click @ui.tabs': 'onTabClick'
    };

    TabsBehavior.prototype.onRender = function() {
      return this.activate(this.ui.tabActive);
    };

    TabsBehavior.prototype.onShow = function() {
      return this.activate(this.ui.tabActive);
    };

    TabsBehavior.prototype.onTabClick = function(event, b) {
      var target;
      event.preventDefault();
      target = $(event.currentTarget);
      this.activate(target);
      return this.view.triggerMethod('cmi:tabs:click', target);
    };

    TabsBehavior.prototype.activate = function(domElement) {
      return CMI.Tabs.activate(domElement);
    };

    return TabsBehavior;

  })(Marionette.Behavior);

}).call(this);
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.CMI || (window.CMI = {});

  CMI.FormTextFieldBehavior = (function(superClass) {
    extend(FormTextFieldBehavior, superClass);

    function FormTextFieldBehavior() {
      return FormTextFieldBehavior.__super__.constructor.apply(this, arguments);
    }

    FormTextFieldBehavior.inputSelectors = function() {
      return '.cmi-text-input input, .cmi-text-input textarea';
    };

    FormTextFieldBehavior.prototype.ui = {
      inputs: "" + (FormTextFieldBehavior.inputSelectors())
    };

    FormTextFieldBehavior.prototype.events = {
      'change @ui.inputs': 'onInputChange',
      'focus @ui.inputs': 'onInputFocus',
      'blur @ui.inputs': 'onInputBlur'
    };

    FormTextFieldBehavior.prototype.onRender = function() {
      if ((this.ui.inputs != null) === true && this.ui.inputs.length > 0) {
        return this.ui.inputs.each(function() {
          return CMI.FormComponents.TextField.reset($(this));
        });
      }
    };

    FormTextFieldBehavior.prototype.onInputChange = function(event) {
      return CMI.FormComponents.TextField.animateChange($(event.currentTarget));
    };

    FormTextFieldBehavior.prototype.onInputFocus = function(event) {
      return CMI.FormComponents.TextField.animateFocus($(event.currentTarget));
    };

    FormTextFieldBehavior.prototype.onInputBlur = function(event) {
      return CMI.FormComponents.TextField.animateBlur($(event.currentTarget));
    };

    return FormTextFieldBehavior;

  })(Marionette.Behavior);

}).call(this);
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.CMI || (window.CMI = {});

  CMI.FormTextareaBehavior = (function(superClass) {
    extend(FormTextareaBehavior, superClass);

    function FormTextareaBehavior() {
      return FormTextareaBehavior.__super__.constructor.apply(this, arguments);
    }

    FormTextareaBehavior.prototype.behaviors = {
      CMITextFields: {
        behaviorClass: CMI.FormTextFieldBehavior
      }
    };

    FormTextareaBehavior.prototype.ui = {
      textareas: '.cmi-text-input textarea'
    };

    FormTextareaBehavior.prototype.events = {
      'keyup @ui.textareas': 'onKeyUp',
      'keydown @ui.textareas': 'onKeyDown'
    };

    FormTextareaBehavior.prototype.onRender = function() {
      var reference;
      reference = this.$el;
      return this.ui.textareas.each(function() {
        return CMI.FormComponents.Textarea.animateHeight(reference, $(this));
      });
    };

    FormTextareaBehavior.prototype.onKeyUp = function(event) {
      var target;
      target = $(event.currentTarget);
      return CMI.FormComponents.Textarea.animateHeight(this.$el, target);
    };

    FormTextareaBehavior.prototype.onKeyDown = function(event) {
      var target;
      target = $(event.currentTarget);
      return CMI.FormComponents.Textarea.animateHeight(this.$el, target);
    };

    FormTextareaBehavior.prototype.onCmiTextareaRefresh = function() {
      return this.onRender();
    };

    return FormTextareaBehavior;

  })(Marionette.Behavior);

}).call(this);
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.CMI || (window.CMI = {});

  CMI.FormCheckboxBehavior = (function(superClass) {
    extend(FormCheckboxBehavior, superClass);

    function FormCheckboxBehavior() {
      return FormCheckboxBehavior.__super__.constructor.apply(this, arguments);
    }

    FormCheckboxBehavior.prototype.ui = {
      checkboxLabels: '.cmi-checkbox-container label'
    };

    FormCheckboxBehavior.prototype.events = {
      'click @ui.checkboxLabels': 'onLabelClick'
    };

    FormCheckboxBehavior.prototype.onRender = function() {
      return this.ui.checkboxLabels.each(function() {
        return CMI.FormComponents.Checkbox.reset($(this));
      });
    };

    FormCheckboxBehavior.prototype.onLabelClick = function(event) {
      var target;
      event.preventDefault();
      target = $(event.currentTarget);
      CMI.FormComponents.Checkbox.click(target);
      return this.view.triggerMethod('cmi:checkbox:click', target);
    };

    return FormCheckboxBehavior;

  })(Marionette.Behavior);

}).call(this);
(function() {


}).call(this);
