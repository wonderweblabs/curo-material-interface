require 'curo_material_interface/roboto_files'

module CuroMaterialInterface
  class Engine < ::Rails::Engine

    initializer 'curo.add_precompile_assets' do |app|
      app.config.assets.precompile += CuroMaterialInterface::ROBOTO_FILES.map{ |f| File.join('roboto', f) }

      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.eot'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.svg'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.ttf'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.woff'
      app.config.assets.precompile << 'mdi/materialdesignicons-webfont.woff2'
    end

  end
end





