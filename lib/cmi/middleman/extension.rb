module CMI
  module Middleman
    #
    # options:
    #   * components_paths
    #   * components_relative_to_source_paths
    #
    class Extension < ::Middleman::Extension

      option :components_paths, [], 'Lookup paths for components'
      option :components_relative_to_source_paths, [], 'Lookup paths for components relative to middleman source path'

      def after_configuration
        if options.components_paths.present?
          options.components_paths.each{ |path| app.sprockets.append_path(path) }
        end
      end

      helpers do

        def cmi_web_components(options = {})
          context = CMI::WebComponents::Context::Middleman.new(self, extensions[:cmi_middleman_extension])
          builder = CMI::WebComponents::Builder.new(context, options)

          builder.html
        end

      end

    end
  end
end

::Middleman::Extensions.register(:cmi_middleman_extension, CMI::Middleman::Extension)