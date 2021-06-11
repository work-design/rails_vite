module Viter
  class Instance
    cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

    attr_reader :root_path, :config_path

    def initialize(root_path: Rails.root, config_path: Rails.root.join('config/viter.yml'))
      @root_path = root_path
      @config_path = config_path
    end

    def env
      @env ||= Env.inquire self
    end

    def config
      @config ||= Configuration.new(
        root_path: root_path,
        config_path: config_path,
        env: env
      )
    end

    def compiler
      @compiler ||= Compiler.new self
    end

    def dev_server
      @dev_server ||= DevServer.new config
    end

    def manifest
      @manifest ||= Manifest.new self
    end

    def commands
      @commands ||= Commands.new self
    end

  end
end
