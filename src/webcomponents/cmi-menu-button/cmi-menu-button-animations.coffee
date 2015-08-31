'use strict'

Polymer
  is: "cmi-menu-grow-height-animation"
  behaviors: [ Polymer.NeonAnimationBehavior ]
  configure: (config) ->
    node = config.node
    rect = node.getBoundingClientRect()
    height = rect.height
    @_effect = new KeyframeEffect(node, [
      height: (height / 2) + "px"
    ,
      height: height + "px"
     ], @timingFromConfig(config))
    @_effect

Polymer
  is: "cmi-menu-grow-width-animation"
  behaviors: [ Polymer.NeonAnimationBehavior ]
  configure: (config) ->
    node = config.node
    rect = node.getBoundingClientRect()
    width = rect.width
    @_effect = new KeyframeEffect(node, [
      width: (width / 2) + "px"
    ,
      width: width + "px"
     ], @timingFromConfig(config))
    @_effect

Polymer
  is: "cmi-menu-shrink-width-animation"
  behaviors: [ Polymer.NeonAnimationBehavior ]
  configure: (config) ->
    node = config.node
    rect = node.getBoundingClientRect()
    width = rect.width
    @_effect = new KeyframeEffect(node, [
      width: width + "px"
    ,
      width: width - (width / 20) + "px"
     ], @timingFromConfig(config))
    @_effect

Polymer
  is: "cmi-menu-shrink-height-animation"
  behaviors: [ Polymer.NeonAnimationBehavior ]
  configure: (config) ->
    node = config.node
    rect = node.getBoundingClientRect()
    height = rect.height
    top = rect.top
    @setPrefixedProperty node, "transformOrigin", "0 0"
    @_effect = new KeyframeEffect(node, [
      height: height + "px"
      transform: "translateY(0)"
    ,
      height: height / 2 + "px"
      transform: "translateY(-20px)"
     ], @timingFromConfig(config))
    @_effect
