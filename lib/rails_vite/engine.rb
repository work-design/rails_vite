require 'rails_com'

module RailsVite
  class Engine < ::Rails::Engine
    config.vite = ActiveSupport::OrderedOptions.new

    initializer 'rails_vite.bootstrap' do
      if defined?(Rails::Server) || defined?(Rails::Console)
        #RailsVite::Exporter.export
        #RailsVite.bootstrap
      end
    end

  end
end
