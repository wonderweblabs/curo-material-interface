module CMI
  module WebComponents

    #
    # Components register
    #
    # Each component got it's own configuration rb file to
    # declare the e.g. stylesheets or dependencies.
    #
    # Components that should be used needs to be registered
    # here with the path to the component folder.
    #
    mattr_accessor :register
    @@register = {
      :'cmi-button' => File.join(CMI.root, 'lib/components/cmi-button'),
      :'cmi-sidebar' => File.join(CMI.root, 'lib/components/cmi-sidebar'),
    }

  end
end