module CMI
  module WebComponents
    class Builder

      def initialize(context, options = {})
        @context = context
        @options = options
      end

      def html
        html = polymer_html
        html << components_html

        html.html_safe
      end

      def polymer_html
        html = '<script>'
        html << @context.find_asset('cmi/polymer/polymer').source
        html << '</script>'

        html
      end

      def components_html
        options.inject('') do |html, (key, config)|
          html << renderer.render_component(key, config) if config[:enabled] == true

          html
        end
      end

      def options
        CMI.web_components_config.merge(@options)
      end

      def renderer
        CMI::WebComponents::Renderer.new(@context)
      end

    end
  end
end