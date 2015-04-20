require 'curo_material_interface/roboto_files'

module CuroMaterialInterface
  class Engine < ::Rails::Engine

    initializer 'curo.add_precompile_assets' do |app|
      app.config.assets.precompile += CuroMaterialInterface::ROBOTO_FILES.map{ |f| File.join('roboto', f) }

      app.config.assets.precompile << 'mdi/Material-Design-Icons.eot'
      app.config.assets.precompile << 'mdi/Material-Design-Icons.svg'
      app.config.assets.precompile << 'mdi/Material-Design-Icons.ttf'
      app.config.assets.precompile << 'mdi/Material-Design-Icons.woff'
    end

  end
end