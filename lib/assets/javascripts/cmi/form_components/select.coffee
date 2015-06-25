window.CMI or= {}
window.CMI.FormComponents or= {}

class CMI.FormComponents.Select

  @get: (domElement) ->
    domElement = $(domElement) unless domElement instanceof jQuery

    unless domElement.data('cmi-select') instanceof CMI.FormComponents.Select
      domElement.data 'cmi-select', new @(domElement)

    domElement.data 'cmi-select'

  @reset: (domElement) ->
    domElement = $(domElement) unless domElement instanceof jQuery

    @get(domElement)

  @open: (domElement, selectCallback = null) ->
    domElement = $(domElement) unless domElement instanceof jQuery

    @get(domElement).open(selectCallback)

  @close: (domElement) ->
    domElement = $(domElement) unless domElement instanceof jQuery

    @get(domElement).close()

  @select: (domElement, value) ->
    domElement = $(domElement) unless domElement instanceof jQuery

    @get(domElement).select(value)

  @destroy: (domElement) ->
    domElement = $(domElement) unless domElement instanceof jQuery

    @get(domElement).destroy()
    domElement.data 'cmi-select', null


  # ---------------------------------------------

  constructor: (@domElement) ->
    @reset()

  reset: ->
    @_prepare()

  destroy: ->
    @_unbindListeners()
    @_clear()

  open: ->
    return if @domElement.hasClass 'cmi-select-open'

    @_open = true

    @domElement.addClass 'cmi-select-open'
    @getDropdownList().addClass 'cmi-select-open'
    $('body').addClass 'cmi-select-list-open'

    $(window).on 'resize.cmiSelectOpen', $.proxy(@updateDropdownListPosition, @)

    @updateDropdownListPosition()

  close: ->
    return unless @domElement.hasClass 'cmi-select-open'

    $(window).off 'resize.cmiSelectOpen'

    @_open = false

    @domElement.removeClass 'cmi-select-open'
    @getDropdownList().removeClass 'cmi-select-open'
    $('body').removeClass 'cmi-select-list-open'

    CMI.FormComponents.TextField.reset(@getInput())

  select: (value) ->

  getInput: ->
    @domElement.data('cmi-select-input') || $('<div></div>')

  getDropdownList: ->
    @domElement.data('cmi-select-dropdown-list') || $('<div></div>')

  getSelect: ->
    $('select', @domElement)

  getName: ->
    @getSelect().attr 'name'

  getDocumentHeight: ->
    html = document.documentElement
    body = document.body

    Math.max( body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight )

  getViewportHeight: ->
    Math.max(document.documentElement.clientHeight, window.innerHeight || 0)

  getViewportScrollY: ->
    window.scrollY

  updateDropdownListPosition: ->
    offset = @getInput().offset()
    width = @getInput().width()

    # reset
    @getDropdownList().css
      height: 'auto'
      top: 0
      bottom: 'auto'
      width: "#{width}px"
      left: "#{offset.left}px"

    # set the position
    dropdownHeight = @getDropdownList().outerHeight(true)
    dropdownMarginTop = parseInt(@getDropdownList().css('margin-top'))
    pos = { bottom: null, top: offset.top - dropdownMarginTop }

    # adjust position for selected element
    selected = $('.cmi-select-selected', @getDropdownList()).first()
    selectedOffset = selected.offset().top - selected.offsetParent().offset().top
    pos.top = pos.top - selectedOffset

    # fix if top is outside viewport
    if pos.top < @getViewportScrollY()
      pos.top = @getViewportScrollY()

    # fix if bottom is outside viewport
    if pos.top + dropdownHeight > @getDocumentHeight()
      pos.bottom = window.scrollY * -1
      pos.top = null if pos.top > @getViewportScrollY()

    # fix if top is outside viewport
    if pos.top == null && dropdownHeight > @getViewportHeight()
      pos.top = @getViewportScrollY()

    # set position
    pos.top = if pos.top == null then 'auto' else "#{pos.top}px"
    pos.bottom = if pos.bottom == null then 'auto' else "#{pos.bottom}px"
    @getDropdownList().css pos

  onInputClick: ->
    @open()

  onInputFocus: ->
    @open()

  onInputBlur: (event) ->
    @close()

    setTimeout =>
      CMI.FormComponents.TextField.reset(@getInput())
    , 50

  onListClick: (event) ->
    event.preventDefault()
    return unless @_open == true

    selected = $('option:selected', @getSelect())
    selected[0].removeAttribute('selected') if selected.length > 0

    target = $("option[value='#{$(event.target).data('cmi-value')}']", @getSelect())
    target.attr('selected', true)

    @_setValues()
    @getSelect().trigger 'change'

    @close()
    @getInput().stop().delay(250).blur()


  # ---------------------------------------------
  # private methods

  # @nodoc
  _prepare: ->
    return unless @domElement instanceof jQuery
    return unless @domElement.length > 0

    @_initializeInput()
    @_initializeDropdownList()
    @_hideSelect()
    @_setValues()
    @_bindListeners()

    CMI.FormComponents.TextField.reset(@getInput())

  # @nodoc
  _clear: ->
    return unless @domElement instanceof jQuery
    return unless @domElement.length > 0

    @_clearInput()
    @_clearDropdownList()
    @_showSelect()

  # @nodoc
  _initializeInput: ->
    input = $("<input class='cmi-input' readonly='true' />")

    @domElement.data 'cmi-select-input', input
    @domElement.prepend input

  # @nodoc
  _clearInput: ->
    return unless @domElement.data('cmi-select-input') instanceof jQuery

    @domElement.data('cmi-select-input').remove()
    @domElement.data 'cmi-select-input', null

  # @nodoc
  _initializeDropdownList: ->
    options = []
    for option in $('option', @getSelect())
      content = $(option).html()
      content = '&nbsp;' if content.length <= 0
      options.push "<li data-cmi-value='#{$(option).val()}'>#{content}</li>"

    dropdownList = $("<ul class='cmi-select-list'>#{options.join('')}</ul>")

    @domElement.data 'cmi-select-dropdown-list', dropdownList
    $('body').append dropdownList

  # @nodoc
  _clearDropdownList: ->
    return unless @domElement.data('cmi-select-dropdown-list') instanceof jQuery

    @domElement.data('cmi-select-dropdown-list').remove()
    @domElement.data 'cmi-select-dropdown-list', null

  # @nodoc
  _hideSelect: ->
    @getSelect().addClass 'cmi-select-select-hidden'

  # @nodoc
  _showSelect: ->
    @getSelect().removeClass 'cmi-select-select-hidden'

  # @nodoc
  _setValues: ->
    selected = $('option:selected', @getSelect())
    return if selected.length <= 0

    content = selected.text()
    value = selected.val()

    if selected.data('cmi-input-content') && selected.data('cmi-input-content').length > 0
      content = selected.data('cmi-input-content')

    @getInput().val content

    $("li", @getDropdownList()).removeClass 'cmi-select-selected'
    $("li[data-cmi-value='#{value}']", @getDropdownList()).addClass 'cmi-select-selected'


  # @nodoc
  _bindListeners: ->
    @getDropdownList().on "mousedown.cmiInput#{@getName()}", 'li', $.proxy(@onListClick, @)

    @getInput().on "focus.cmiInput#{@getName()}", $.proxy(@onInputFocus, @)
    @getInput().on "click.cmiInput#{@getName()}", $.proxy(@onInputClick, @)
    @getInput().on "blur.cmiInput#{@getName()}", $.proxy(@onInputBlur, @)

  # @nodoc
  _unbindListeners: ->
    @getDropdownList().off "mousedown.cmiInput#{@getName()}", 'li'

    @getInput().off "focus.cmiInput#{@getName()}"
    @getInput().off "blur.cmiInput#{@getName()}"


