require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inquiry'
require 'active_support/logger'
require 'active_support/tagged_logging'

module Viter
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Viter::Instance.new
  end

  def with_node_env(env)
    original = ENV['NODE_ENV']
    ENV['NODE_ENV'] = env
    yield
  ensure
    ENV['NODE_ENV'] = original
  end

  def ensure_log_goes_to_stdout
    old_logger = Viter.logger
    Viter.logger = ActiveSupport::Logger.new(STDOUT)
    yield
  ensure
    Viter.logger = old_logger
  end

  delegate :logger, :logger=, :env, to: :instance
  delegate :config, :compiler, :manifest, :commands, :dev_server, to: :instance
  delegate :bootstrap, :clean, :clobber, :compile, to: :commands
end

require 'viter/instance'
require 'viter/env'
require 'viter/configuration'
require 'viter/manifest'
require 'viter/compiler'
require 'viter/commands'
require 'viter/dev_server'

require 'viter/railtie' if defined?(Rails)
