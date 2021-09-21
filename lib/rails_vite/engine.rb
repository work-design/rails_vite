require 'rails_com/all'

module RailsVite
  class Engine < ::Rails::Engine
    # Allows RailsVite config values to be set via Rails env config files
    config.rails_vite = ActiveSupport::OrderedOptions.new

    initializer 'rails_vite.bootstrap' do
      if defined?(Rails::Server) || defined?(Rails::Console)
        RailsVite.bootstrap
      end
    end

  end
end
