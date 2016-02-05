# 'use strict'

# # Polymer
# Polymer

#   is: 'cmi-input-char-counter'

#   behaviors: [
#     Polymer.PaperInputAddonBehavior
#   ]

#   properties:
#     _charCounterStr: { type: String, value: '0' }

#   update: (state) ->
#     return if !state.inputElement

#     state.value = state.value || ''

#     # Account for the textarea's new lines.
#     str = state.value.replace(/(\r\n|\n|\r)/g, '--').length
#     str += '/' + state.inputElement.getAttribute('maxlength') if state.inputElement.hasAttribute('maxlength')

#     @_charCounterStr = str
