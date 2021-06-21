require 'rails/railtie'
require 'viter/exporter'

module Viter
  class Engine < ::Rails::Engine
    # Allows Viter config values to be set via Rails env config files
    config.viter = ActiveSupport::OrderedOptions.new

    initializer 'viter.logger' do
      config.after_initialize do
        if ::Rails.logger.respond_to?(:tagged)
          Viter.logger = ::Rails.logger
        else
          Viter.logger = ActiveSupport::TaggedLogging.new(::Rails.logger)
        end
      end
    end

    initializer 'viter.bootstrap' do
      if defined?(Rails::Server) || defined?(Rails::Console)
        Viter.bootstrap
        if defined?(Spring)
          require 'spring/watcher'
          Spring.after_fork { Viter.bootstrap }
          Spring.watch(Viter.config.config_path)
        end
      end
    end

    config.after_initialize do |app|
      Viter::Exporter.export
      ENV['VITER_ASSET_HOST'] ||= ActionController::Base.helpers.compute_asset_host
    end

  end
end
