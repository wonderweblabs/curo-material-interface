module CMI
  module WebComponents
    class Renderer

      #
      # Init.
      #
      # Context is used to call serveral app type dependent
      # methods on. For example the render method.
      #
      # See CMI::WebComponents::Context::* classes for more information.
      #
      def initialize(context)
        @context = context
      end

      #
      # Delegates the render call to context.
      #
      def render(data)
        @context.render(data)
      end

      #
      # Returns the rendered asset file for the passed options.
      #
      # Calls find_asset on context.
      #
      def render_asset(name, type, options = {})
        asset_path = if options[type].present?
          @context.register_asset(options[type])

          options[:stylesheet]
        else
          "#{name.to_s}/component.#{type == :stylesheet ? 'css' : 'js'}"
        end

        @context.find_asset(asset_path).source
      end

      #
      # Generates the basic component data. Since the data might
      # be different on different contexts, it is just delegated
      # to the context object.
      #
      def render_component_data(name)
        @context.render_component_data(name)
      end

      #
      # Calls render with render_component_data merged with locals_hash.
      #
      def render_component(name, options = {})
        render render_component_data(name).merge({
          locals: locals_hash(name, options)
        })
      end

      #
      # General locals hash.
      #
      def locals_hash(name, options = {})
        {
          stylesheet: render_asset(name, :stylesheet, options),
          javascript: render_asset(name, :javascript, options),
        }
      end

    end
  end
end