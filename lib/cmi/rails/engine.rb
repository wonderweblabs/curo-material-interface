require 'cmi/roboto_files'

module CMI
  class Engine < ::Rails::Engine

    initializer 'cmi.add_precompile_assets' do |app|
      app.config.assets.precompile += CMI::ROBOTO_FILES.map{ |f| File.join('roboto', f) }

      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.eot'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.svg'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.ttf'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.woff'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.woff2'
    end

    # add cmi helpers to app
    initializer 'cmi.add_page_helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include CMI::Rails::ComponentsHelper
      end
    end

    # add web components paths
    initializer 'cmi.web_components_paths' do |app|
      path = File.join(CMI.root, 'lib/components')

      config.assets.paths << path
      CMI::WebComponents::Context::Rails.view_paths << path
    end

  end
end





