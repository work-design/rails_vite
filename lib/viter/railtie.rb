require 'rails/railtie'

class Viter::Engine < ::Rails::Engine
  # Allows Viter config values to be set via Rails env config files
  config.viter = ActiveSupport::OrderedOptions.new

  initializer 'webpacker.logger' do
    config.after_initialize do
      if ::Rails.logger.respond_to?(:tagged)
        Viter.logger = ::Rails.logger
      else
        Viter.logger = ActiveSupport::TaggedLogging.new(::Rails.logger)
      end
    end
  end

  initializer 'webpacker.bootstrap' do
    if defined?(Rails::Server) || defined?(Rails::Console)
      Viter.bootstrap
      if defined?(Spring)
        require 'spring/watcher'
        Spring.after_fork { Viter.bootstrap }
        Spring.watch(Viter.config.config_path)
      end
    end
  end

  initializer 'webpacker.set_source' do |app|
    if Viter.config.config_path.exist?
      #app.config.javascript_path = Viter.config.source_path.relative_path_from(Rails.root.join('app')).to_s
    end
  end

  config.after_initialize do |app|
    RailsUi::Exporter.export
  end

end
