module RailsVite
  class DevServer

    # Configure dev server connection timeout (in seconds), default: 0.01
    # Webpacker.server.connect_timeout = 1
    # cattr_accessor(:connect_timeout) { 0.01 }
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def running?
      if config.server.present?
        Socket.tcp(host, port, connect_timeout: connect_timeout).close
        true
      else
        false
      end
    rescue
      false
    end

    def host
      fetch(:host)
    end

    def port
      fetch(:port)
    end

    def https?
      case fetch(:https)
      when true, 'true', Hash
        true
      else
        false
      end
    end

    def protocol
      https? ? 'https' : 'http'
    end

    def host_with_port
      "#{host}:#{port}"
    end

    def pretty?
      fetch(:pretty)
    end

    private
    def fetch(key)
      config.fetch(key)
    end

  end
end
