module CMI
  module Rails
    module ComponentsHelper

      def cmi_web_components(options = {})
        context = CMI::WebComponents::Context::Rails.new()
        builder = CMI::WebComponents::Builder.new(context, options)

        builder.html
      end

    end
  end
end