require 'shellwords'
require 'socket'
require 'viter/configuration'
require 'viter/dev_server'
require 'viter/runner'

module Viter
  class DevServerRunner < Runner

    def run
      load_config
      detect_unsupported_switches!
      detect_port!
      execute_cmd
    end

    private

    def load_config
      app_root = Pathname.new(@app_path)

      @config = Configuration.new(
        root_path: app_root,
        config_path: app_root.join('config/viter.yml'),
        env: ENV['RAILS_ENV']
      )

      server = DevServer.new(@config)
      @hostname = server.host
      @port = server.port
      @pretty = server.pretty?
      @https = server.https?

    rescue Errno::ENOENT, NoMethodError
      $stdout.puts "webpack server configuration not found in #{@config.config_path}[#{ENV["RAILS_ENV"]}]."
      $stdout.puts "Please run bundle exec rails webpacker:install to install Webpacker"
      exit!
    end

    UNSUPPORTED_SWITCHES = %w[--host --port]
    private_constant :UNSUPPORTED_SWITCHES
    def detect_unsupported_switches!
      unsupported_switches = UNSUPPORTED_SWITCHES & @argv
      if unsupported_switches.any?
        $stdout.puts "The following CLI switches are not supported by Webpacker: #{unsupported_switches.join(' ')}. Please edit your command and try again."
        exit!
      end

      if @argv.include?("--https") && !@https
        $stdout.puts "Please set https: true in webpacker.yml to use the --https command line flag."
        exit!
      end
    end

    def detect_port!
      server = TCPServer.new(@hostname, @port)
      server.close

    rescue Errno::EADDRINUSE
      $stdout.puts "Another program is running on port #{@port}. Set a new port in #{@config.config_path} for server"
      exit!
    end

    def execute_cmd
      cmd = if node_modules_bin_exist?
        ["#{@node_modules_bin_path}/vite"]
      else
        ['yarn', 'vite']
      end

      if @argv.include?('--debug-viter')
        cmd = ['node', '--inspect-brk'] + cmd
        @argv.delete '--debug-viter'
      end

      cmd += ['--config', @vite_config]
      cmd += ['--progress', '--color'] if @pretty
      cmd += @argv

      Dir.chdir(@app_path) do
        Kernel.exec *cmd
      end
    end

    def node_modules_bin_exist?
      File.exist?("#{@node_modules_bin_path}/vite")
    end

  end
end
