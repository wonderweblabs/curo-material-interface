module CMI
  module WebComponents
    module Context
      class Rails < CMI::WebComponents::Context::Abstract

        class << self

          def view_paths
            @view_paths ||= []
          end

        end

        def find_asset(asset_path)
          ::Rails.application.assets.find_asset(asset_path)
        end

        def register_asset(asset_path); end

        def render(data)
          result = action_view.render file: data[:relative_path], locals: data[:locals]

          result.is_a?(::Array) ? result.join('') : result
        end

        def render_component_data(name)
          { relative_path: "#{name}/component.html" }
        end

        private

        def view_paths
          CMI::WebComponents::Context::Rails.view_paths
        end

        def action_view
          ActionView::Base.new(view_paths, {}, action_controller)
        end

        def action_controller
          ActionController::Base.new
        end

      end
    end
  end
end