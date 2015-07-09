module CMI
  module WebComponents
    module Context
      class Abstract

        def find_asset(asset_path)
          raise 'Implement find_asset to return the sprockets find_asset result.'
        end

        def register_asset(asset_path)
          raise 'Implement register_asset if used assets need to be registered before.'
        end

        def render(data)
          raise 'Implement render to render the component file based on the passed data.'
        end

        def render_component_data(name)
          raise <<-EOS
            Implement render_component_data to return the configuration data that will
            be extended and passed to the render method later on.
          EOS
        end

      end
    end
  end
end