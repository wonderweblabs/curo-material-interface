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
    @_prepareDom()

  destroy: ->
    @_unbindListeners()

    @getInput().remove()
    @getList().remove()
    @getSelect().removeClass 'cmi-select-select-hidden'

  reset: ->
    @_prepareDom()

  close: ->
    return unless @domElement.hasClass 'cmi-select-open'

    @domElement.removeClass 'cmi-select-open'
    @_open = false

    CMI.FormComponents.TextField.reset(@getInput())

  select: (value) ->

  getInput: ->
    $('input.cmi-input', @domElement)

  getList: ->
    $('ul.cmi-select-list', @domElement)

  getSelect: ->
    $('select', @domElement)

  getName: ->
    @getSelect().attr 'name'


  onInputClick: ->
    @domElement.addClass 'cmi-select-open'
    @_open = true

  onInputFocus: ->
    @domElement.addClass 'cmi-select-open'
    @_open = true

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
  _prepareDom: ->
    @_addInput()
    @_addList()
    @_hideSelect()
    @_setValues()
    @_bindListeners()

    CMI.FormComponents.TextField.reset(@getInput())

  # @nodoc
  _addInput: ->
    return if @getInput().length > 0

    @domElement.prepend $("<input class='cmi-input' readonly='true' />")

  # @nodoc
  _addList: ->
    return if @getList().length > 0

    options = []
    for option in $('option', @getSelect())
      content = $(option).html()
      content = '&nbsp;' if content.length <= 0
      options.push "<li data-cmi-value='#{$(option).val()}'>#{content}</li>"

    $("<ul class='cmi-select-list'>#{options.join('')}</ul>").insertBefore @getSelect()

  # @nodoc
  _hideSelect: ->
    @getSelect().addClass 'cmi-select-select-hidden'

  # @nodoc
  _setValues: ->
    selected = $('option:selected', @getSelect())
    return if selected.length <= 0

    content = selected.text()
    value = selected.val()

    if selected.data('cmi-input-content') && selected.data('cmi-input-content').length > 0
      content = selected.data('cmi-input-content')

    @getInput().val content

    $("li", @getList()).removeClass 'cmi-select-selected'
    $("li[data-cmi-value='#{value}']", @getList()).addClass 'cmi-select-selected'


  # @nodoc
  _bindListeners: ->
    @getList().on "mousedown.cmiInput#{@getName()}", 'li', $.proxy(@onListClick, @)

    @getInput().on "focus.cmiInput#{@getName()}", $.proxy(@onInputFocus, @)
    @getInput().on "click.cmiInput#{@getName()}", $.proxy(@onInputClick, @)
    @getInput().on "blur.cmiInput#{@getName()}", $.proxy(@onInputBlur, @)


  # @nodoc
  _unbindListeners: ->
    @getList().off "mousedown.cmiInput#{@getName()}", 'li'

    @getInput().off "focus.cmiInput#{@getName()}"
    @getInput().off "blur.cmiInput#{@getName()}"

