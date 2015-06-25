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
      return $('<div class="cmi-loading-indicator-inside"> <svg class="cmi-circular"> <circle class="cmi-path" cx="50" cy="50" fill="none" r="20" stroke-miterlimit="10" stroke-width="3"></circle> </svg> </div>');
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

    Tabs.activate = function(invoker) {
      var activeTabs, invokersPanel, name, upcomingTab;
      if (!(invoker instanceof jQuery)) {
        invoker = $(invoker);
      }
      if (invoker.length <= 0) {
        return;
      }
      invokersPanel = invoker.parents('.cmi-tabs').first();
      if (invokersPanel.length <= 0) {
        return;
      }
      this._ensureActiveIndicator(invokersPanel);
      name = invokersPanel.data('cmi-tabs-name');
      if ((name != null) === false || name.length <= 0) {
        return;
      }
      upcomingTab = this._tabFromInvoker(invoker, name);
      if (upcomingTab.length <= 0) {
        return;
      }
      if (upcomingTab.hasClass('cmi-tabs-active')) {
        return;
      }
      activeTabs = $("[data-cmi-tabs-name=" + name + "].cmi-tabs-tab.cmi-tabs-active");
      upcomingTab.trigger('cmi.tabs.beforeShow');
      activeTabs.trigger('cmi.tabs.beforeHide');
      this._setAndAnimateActiveIndicator(invokersPanel, invoker);
      upcomingTab.addClass('cmi-tabs-active');
      activeTabs.removeClass('cmi-tabs-active');
      invokersPanel.find('li').removeClass('cmi-tabs-active');
      invoker.parents('li').first().addClass('cmi-tabs-active');
      upcomingTab.trigger('cmi.tabs.show');
      return activeTabs.trigger('cmi.tabs.hide');
    };

    Tabs._ensureActiveIndicator = function(invokersPanel) {
      if (invokersPanel.find('.cmi-tabs-active-indicator').length > 0) {
        return;
      }
      return invokersPanel.append('<li class="cmi-li cmi-tabs-active-indicator"></li>');
    };

    Tabs._tabFromInvoker = function(domElement, name) {
      var id;
      id = domElement.attr('data-cmi-tab-id').replace('#', '');
      return $("[data-cmi-tabs-name=" + name + "]#" + id).first();
    };

    Tabs._setAndAnimateActiveIndicator = function(invokersPanel, invoker) {
      var indicator, left, position, right;
      indicator = invokersPanel.find('.cmi-tabs-active-indicator');
      position = invoker.offsetParent().position();
      left = position.left;
      right = invokersPanel.innerWidth() - left - invoker.outerWidth();
      indicator.removeClass('cmi-tabs-animate-right').removeClass('cmi-tabs-animate-left');
      if (left < indicator.position().left) {
        indicator.addClass('cmi-tabs-animate-left');
      } else {
        indicator.addClass('cmi-tabs-animate-right');
      }
      return indicator.css({
        left: left + "px",
        right: right + "px"
      });
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
      if (domElement.val().length > 0 || domElement.is(':focus')) {
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
          parentDomElement.removeClass('cmi-invalid');
          return parentDomElement.addClass('cmi-valid');
        } else {
          parentDomElement.removeClass('cmi-valid');
          return parentDomElement.addClass('cmi-invalid');
        }
      }
    };

    TextField._getInputBoxSelector = function() {
      return '.cmi-text-input, .cmi-select-input';
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
  var base;

  window.CMI || (window.CMI = {});

  (base = window.CMI).FormComponents || (base.FormComponents = {});

  CMI.FormComponents.Select = (function() {
    Select.get = function(domElement) {
      if (!(domElement instanceof jQuery)) {
        domElement = $(domElement);
      }
      if (!(domElement.data('cmi-select') instanceof CMI.FormComponents.Select)) {
        domElement.data('cmi-select', new this(domElement));
      }
      return domElement.data('cmi-select');
    };

    Select.reset = function(domElement) {
      if (!(domElement instanceof jQuery)) {
        domElement = $(domElement);
      }
      return this.get(domElement);
    };

    Select.open = function(domElement, selectCallback) {
      if (selectCallback == null) {
        selectCallback = null;
      }
      if (!(domElement instanceof jQuery)) {
        domElement = $(domElement);
      }
      return this.get(domElement).open(selectCallback);
    };

    Select.close = function(domElement) {
      if (!(domElement instanceof jQuery)) {
        domElement = $(domElement);
      }
      return this.get(domElement).close();
    };

    Select.select = function(domElement, value) {
      if (!(domElement instanceof jQuery)) {
        domElement = $(domElement);
      }
      return this.get(domElement).select(value);
    };

    Select.destroy = function(domElement) {
      if (!(domElement instanceof jQuery)) {
        domElement = $(domElement);
      }
      this.get(domElement).destroy();
      return domElement.data('cmi-select', null);
    };

    function Select(domElement1) {
      this.domElement = domElement1;
      this.reset();
    }

    Select.prototype.reset = function() {
      return this._prepare();
    };

    Select.prototype.destroy = function() {
      this._unbindListeners();
      return this._clear();
    };

    Select.prototype.open = function() {
      if (this.domElement.hasClass('cmi-select-open')) {
        return;
      }
      this._open = true;
      this.domElement.addClass('cmi-select-open');
      this.getDropdownList().addClass('cmi-select-open');
      $('body').addClass('cmi-select-list-open');
      $(window).on('resize.cmiSelectOpen', $.proxy(this.updateDropdownListPosition, this));
      return this.updateDropdownListPosition();
    };

    Select.prototype.close = function() {
      if (!this.domElement.hasClass('cmi-select-open')) {
        return;
      }
      $(window).off('resize.cmiSelectOpen');
      this._open = false;
      this.domElement.removeClass('cmi-select-open');
      this.getDropdownList().removeClass('cmi-select-open');
      $('body').removeClass('cmi-select-list-open');
      return CMI.FormComponents.TextField.reset(this.getInput());
    };

    Select.prototype.select = function(value) {};

    Select.prototype.getInput = function() {
      return this.domElement.data('cmi-select-input') || $('<div></div>');
    };

    Select.prototype.getDropdownList = function() {
      return this.domElement.data('cmi-select-dropdown-list') || $('<div></div>');
    };

    Select.prototype.getSelect = function() {
      return $('select', this.domElement);
    };

    Select.prototype.getName = function() {
      return this.getSelect().attr('name');
    };

    Select.prototype.getDocumentHeight = function() {
      var body, html;
      html = document.documentElement;
      body = document.body;
      return Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
    };

    Select.prototype.getViewportHeight = function() {
      return Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    };

    Select.prototype.getViewportScrollY = function() {
      return window.scrollY;
    };

    Select.prototype.updateDropdownListPosition = function() {
      var dropdownHeight, dropdownMarginTop, offset, pos, selected, selectedOffset, width;
      offset = this.getInput().offset();
      width = this.getInput().width();
      this.getDropdownList().css({
        height: 'auto',
        top: 0,
        bottom: 'auto',
        width: width + "px",
        left: offset.left + "px"
      });
      dropdownHeight = this.getDropdownList().outerHeight(true);
      dropdownMarginTop = parseInt(this.getDropdownList().css('margin-top'));
      pos = {
        bottom: null,
        top: offset.top - dropdownMarginTop
      };
      selected = $('.cmi-select-selected', this.getDropdownList()).first();
      selectedOffset = selected.offset().top - selected.offsetParent().offset().top;
      pos.top = pos.top - selectedOffset;
      if (pos.top < this.getViewportScrollY()) {
        pos.top = this.getViewportScrollY();
      }
      if (pos.top + dropdownHeight > this.getDocumentHeight()) {
        pos.bottom = window.scrollY * -1;
        if (pos.top > this.getViewportScrollY()) {
          pos.top = null;
        }
      }
      if (pos.top === null && dropdownHeight > this.getViewportHeight()) {
        pos.top = this.getViewportScrollY();
      }
      pos.top = pos.top === null ? 'auto' : pos.top + "px";
      pos.bottom = pos.bottom === null ? 'auto' : pos.bottom + "px";
      return this.getDropdownList().css(pos);
    };

    Select.prototype.onInputClick = function() {
      return this.open();
    };

    Select.prototype.onInputFocus = function() {
      return this.open();
    };

    Select.prototype.onInputBlur = function(event) {
      this.close();
      return setTimeout((function(_this) {
        return function() {
          return CMI.FormComponents.TextField.reset(_this.getInput());
        };
      })(this), 50);
    };

    Select.prototype.onListClick = function(event) {
      var selected, target;
      event.preventDefault();
      if (this._open !== true) {
        return;
      }
      selected = $('option:selected', this.getSelect());
      if (selected.length > 0) {
        selected[0].removeAttribute('selected');
      }
      target = $("option[value='" + ($(event.target).data('cmi-value')) + "']", this.getSelect());
      target.attr('selected', true);
      this._setValues();
      this.getSelect().trigger('change');
      this.close();
      return this.getInput().stop().delay(250).blur();
    };

    Select.prototype._prepare = function() {
      if (!(this.domElement instanceof jQuery)) {
        return;
      }
      if (!(this.domElement.length > 0)) {
        return;
      }
      this._initializeInput();
      this._initializeDropdownList();
      this._hideSelect();
      this._setValues();
      this._bindListeners();
      return CMI.FormComponents.TextField.reset(this.getInput());
    };

    Select.prototype._clear = function() {
      if (!(this.domElement instanceof jQuery)) {
        return;
      }
      if (!(this.domElement.length > 0)) {
        return;
      }
      this._clearInput();
      this._clearDropdownList();
      return this._showSelect();
    };

    Select.prototype._initializeInput = function() {
      var input;
      input = $("<input class='cmi-input' readonly='true' />");
      this.domElement.data('cmi-select-input', input);
      return this.domElement.prepend(input);
    };

    Select.prototype._clearInput = function() {
      if (!(this.domElement.data('cmi-select-input') instanceof jQuery)) {
        return;
      }
      this.domElement.data('cmi-select-input').remove();
      return this.domElement.data('cmi-select-input', null);
    };

    Select.prototype._initializeDropdownList = function() {
      var content, dropdownList, i, len, option, options, ref;
      options = [];
      ref = $('option', this.getSelect());
      for (i = 0, len = ref.length; i < len; i++) {
        option = ref[i];
        content = $(option).text();
        if (content.length <= 0) {
          content = '&nbsp;';
        }
        options.push("<li data-cmi-value='" + ($(option).val()) + "'>" + content + "</li>");
      }
      dropdownList = $("<ul class='cmi-select-list'>" + (options.join('')) + "</ul>");
      this.domElement.data('cmi-select-dropdown-list', dropdownList);
      return $('body').append(dropdownList);
    };

    Select.prototype._clearDropdownList = function() {
      if (!(this.domElement.data('cmi-select-dropdown-list') instanceof jQuery)) {
        return;
      }
      this.domElement.data('cmi-select-dropdown-list').remove();
      return this.domElement.data('cmi-select-dropdown-list', null);
    };

    Select.prototype._hideSelect = function() {
      return this.getSelect().addClass('cmi-select-select-hidden');
    };

    Select.prototype._showSelect = function() {
      return this.getSelect().removeClass('cmi-select-select-hidden');
    };

    Select.prototype._setValues = function() {
      var content, selected, value;
      selected = $('option:selected', this.getSelect());
      if (selected.length <= 0) {
        return;
      }
      content = selected.text();
      value = selected.val();
      if (selected.data('cmi-input-content') && selected.data('cmi-input-content').length > 0) {
        content = selected.data('cmi-input-content');
      }
      this.getInput().val(content);
      $("li", this.getDropdownList()).removeClass('cmi-select-selected');
      return $("li[data-cmi-value='" + value + "']", this.getDropdownList()).addClass('cmi-select-selected');
    };

    Select.prototype._bindListeners = function() {
      this.getDropdownList().on("mousedown.cmiInput" + (this.getName()), 'li', $.proxy(this.onListClick, this));
      this.getInput().on("focus.cmiInput" + (this.getName()), $.proxy(this.onInputFocus, this));
      this.getInput().on("click.cmiInput" + (this.getName()), $.proxy(this.onInputClick, this));
      return this.getInput().on("blur.cmiInput" + (this.getName()), $.proxy(this.onInputBlur, this));
    };

    Select.prototype._unbindListeners = function() {
      this.getDropdownList().off("mousedown.cmiInput" + (this.getName()), 'li');
      this.getInput().off("focus.cmiInput" + (this.getName()));
      return this.getInput().off("blur.cmiInput" + (this.getName()));
    };

    return Select;

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
      tabActive: '.cmi-tabs > li.cmi-tabs-active > a',
      tabsNavigation: '.cmi-tabs'
    };

    TabsBehavior.prototype.events = {
      'click @ui.tabs': 'onTabClick'
    };

    TabsBehavior.prototype.onRender = function() {
      return this.onCmiTabsRefresh();
    };

    TabsBehavior.prototype.onShow = function() {
      return this.activate(this.ui.tabActive);
    };

    TabsBehavior.prototype.onCmiTabsRefresh = function() {
      this.view.bindUIElements();
      return this.activate(this.ui.tabActive);
    };

    TabsBehavior.prototype.onTabClick = function(event, b) {
      var target;
      event.preventDefault();
      target = $(event.currentTarget);
      this.activate(target);
      return this.view.triggerMethod('cmi:tabs:click', target);
    };

    TabsBehavior.prototype.getTabsName = function() {
      return this.ui.tabsNavigation.data('cmi-tabs-name');
    };

    TabsBehavior.prototype.getCurrentTab = function() {
      return $("[data-cmi-tabs-name=" + (this.getTabsName()) + "].cmi-tabs-tab.cmi-tabs-active");
    };

    TabsBehavior.prototype.getTabForNavigationElement = function(domElement) {
      var id;
      id = domElement.data('cmi-tab-id').replace('#', '');
      return $("[data-cmi-tabs-name=" + (this.getTabsName()) + "]#" + id + ".cmi-tabs-tab");
    };

    TabsBehavior.prototype.activate = function(domElement) {
      var currentDomElement;
      if (!(domElement instanceof jQuery)) {
        return;
      }
      if (!(domElement.length > 0)) {
        return;
      }
      if (domElement === this.getCurrentTab()) {
        return;
      }
      currentDomElement = this.getCurrentTab();
      if (!(currentDomElement instanceof jQuery && currentDomElement.length > 0)) {
        currentDomElement = null;
      }
      this.view.triggerMethod('cmi:tabs:tab:beforeShow', this.getTabForNavigationElement(domElement));
      if ((currentDomElement != null) === true) {
        this.view.triggerMethod('cmi:tabs:tab:beforeHide', currentDomElement);
      }
      CMI.Tabs.activate(domElement);
      if ((currentDomElement != null) === true) {
        this.view.triggerMethod('cmi:tabs:tab:hide', currentDomElement);
      }
      return this.view.triggerMethod('cmi:tabs:tab:show', this.getTabForNavigationElement(domElement));
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
      return this.onCmiFormTextFieldsReset();
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

    FormTextFieldBehavior.prototype.onCmiFormTextFieldsReset = function() {
      var _self;
      if (!(this.ui.inputs instanceof jQuery)) {
        return;
      }
      if (!(this.ui.inputs.length > 0)) {
        return;
      }
      _self = this;
      return this.ui.inputs.each(function() {
        return _self.onCmiFormTextFieldReset($(this));
      });
    };

    FormTextFieldBehavior.prototype.onCmiFormTextFieldReset = function(domElement) {
      if (!(domElement instanceof jQuery)) {
        return;
      }
      return CMI.FormComponents.TextField.reset(domElement);
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
