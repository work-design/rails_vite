require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inquiry'
require 'active_support/logger'
require 'active_support/tagged_logging'

module RailsVite
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= RailsVite::Instance.new
  end

  def with_node_env(env)
    original = ENV['NODE_ENV']
    ENV['NODE_ENV'] = env
    yield
  ensure
    ENV['NODE_ENV'] = original
  end

  def ensure_log_goes_to_stdout
    old_logger = RailsVite.logger
    RailsVite.logger = ActiveSupport::Logger.new(STDOUT)
    yield
  ensure
    RailsVite.logger = old_logger
  end

  delegate :logger, :logger=, :env, to: :instance
  delegate :config, :compiler, :manifest, :commands, :dev_server, to: :instance
  delegate :bootstrap, :clean, :clobber, :compile, to: :commands
end

require 'rails_vite/instance'
require 'rails_vite/env'
require 'rails_vite/configuration'
require 'rails_vite/manifest'
require 'rails_vite/compiler'
require 'rails_vite/commands'
require 'rails_vite/dev_server'
require 'rails_vite/exporter'
require 'rails_vite/engine'
require 'rails_vite/template_renderer'
require 'rails_vite/dev_server_runner'
