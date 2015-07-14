Polymer

  is: 'cmi-sidebar'

  listeners:
    'cmi-sidebar-background.tap': 'onBackgroundTap'

  onBackgroundTap: (event) ->
    @.toggleClass('cmi-sidebar-visible', false)