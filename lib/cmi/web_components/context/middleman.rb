module CMI
  module WebComponents
    module Context
      class Middleman < CMI::WebComponents::Context::Abstract

        def initialize(app, cmi_extension)
          @app = app
          @extension = cmi_extension
        end

        def find_asset(asset_path)
          @app.sprockets.find_asset(asset_path)
        end

        def register_asset(asset_path)
          return unless File.exist?(asset_path)
          return if paths.include?(File.dirname(asset_path))

          @app.sprockets.append_path File.dirname(asset_path)
        end

        def render(data)
          @app.render nil, data[:relative_path], {
            layout: false,
            template_body: data[:body],
            locals: data[:locals]
          }
        end

        def render_component_data(name)
          data = {
            relative_path: nil,
            absolute_path: nil,
            body: '',
            component_file_path: "#{name}/component.html"
          }

          relative_to_source_paths.each do |path|
            next unless data[:relative_path].nil?
            next unless partial_absolute_path File.join(path, data[:component_file_path])

            data[:relative_path] = File.join(path, data[:component_file_path])
            data[:absolute_path] = partial_absolute_path data[:relative_path]
          end

          data[:body] = read_file(data[:absolute_path])
          data
        end


        def partial_absolute_path(path)
          @app.locate_partial(path, false)
        end

        def read_file(path)
          file = ::File.open(path, 'rb') { |io| io.read }

          if file.respond_to?(:force_encoding) && ::Encoding.default_external
            file.force_encoding(::Encoding.default_external)
          end

          file
        end

        def options
          @extension.options
        end

        def paths
          options.components_paths
        end

        def relative_to_source_paths
          options.components_relative_to_source_paths
        end

      end
    end
  end
end