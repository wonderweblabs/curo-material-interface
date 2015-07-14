# module
module CMI

  # root path
  def self.root
    File.expand_path '../..', __FILE__
  end

  #
  # Default components configuration. It configures, which components are
  # rendered and optionally each entry takes a stylesheet or/and a javascript
  # to overwrite the existing version.
  #
  # E.g. {
  #   :'cmi-sidebar' => {
  #     enabled: true,
  #     stylesheet: 'custom/stylesheet',
  #     javascript: 'custom/javascript',
  #   },
  # }
  #
  def self.web_components_config
    @@web_components_config ||= {
      :'cmi-sidebar' => { enabled: true },
      :'cmi-button' => { enabled: true },
    }
  end
  def self.web_components_config=(config)
    @@web_components_config = config
  end

  require 'cmi/rails' if defined?(Rails)
  require 'cmi/middleman' if defined?(Middleman)

end