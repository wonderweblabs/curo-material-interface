'use strict'

# Polymer
Polymer

  is: 'cmi-doc-code-box'

  properties:
    contentHtml:  { type: String, observer: '_onContentHtmlChanged' }
    leftCols:     { type: Number, value: 6, notify: true }
    rightCols:    { type: Number, value: 6, notify: true }

  created: ->
    contentHtml = @root.innerHTML
    @async => @contentHtml = contentHtml

  _computeLeftColClasses: (cols) ->
    "col-left grid-col-#{cols}"

  _computeRightColClasses: (cols) ->
    "col-right grid-col-#{cols}"

  _onContentHtmlChanged: ->
    lines = @contentHtml.split('\n')
    stack = []
    former = 'close'
    indentation = '    '
    level = 0
    resultLines = []
    exludedTags = [
      'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'input',
      'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr'
    ]

    for line in lines
      closing = if /^\s*<\//.test(line) then true else false

      times = if closing == true then stack.length else stack.length + 1
      resultLines.push "#{Array(times).join(indentation)}#{line}"

      for tag in (line.match(/(?:<\/)([^\s>\/>]*)/gm) || [])
        tag = tag.replace(/^<\//, '')

        continue if tag.length <= 0 || tag == '<'
        continue if exludedTags.indexOf(tag) >= 0

        stack = stack.slice(0, -1) if stack.length > 0

      for tag in (line.match(/(?:<)([^\s>\/>]*)/gm) || [])
        tag = tag.replace(/^</, '')

        continue if tag.length <= 0 || tag == '<'
        continue if exludedTags.indexOf(tag) >= 0

        stack.push tag

    code = Prism.highlight((resultLines.join('\n') || ''), Prism.languages.markup)
    @.$.code.innerHTML = code


