require 'shellwords'
require 'socket'
require 'rails_vite/configuration'
require 'rails_vite/dev_server'
require 'rails_vite/runner'

module RailsVite
  class DevServerRunner < Runner

    def run
      load_config
      execute_cmd
    end

    private

    def load_config
      app_root = Pathname.new(@app_path)

      @config = Configuration.new(
        root_path: app_root,
        config_path: app_root.join('config/vite.yml'),
        env: ENV['RAILS_ENV']
      )

      server = DevServer.new(@config)
      @hostname = server.host
      @port = server.port
      @pretty = server.pretty?
      @https = server.https?

    rescue Errno::ENOENT, NoMethodError
      $stdout.puts "vite configuration not found in #{@config.config_path}[#{ENV["RAILS_ENV"]}]."
      $stdout.puts "Please run bundle exec rails rails_vite:install to install rails_vite"
      exit!
    end

    def execute_cmd
      cmd = ['yarn', 'vite']

      if @argv.include?('--debug-rails_vite')
        cmd = ['node', '--inspect-brk'] + cmd
        @argv.delete '--debug-rails_vite'
      end

      cmd += @argv
      cmd += ['--config', @vite_config]
      cmd += ['--progress', '--color'] if @pretty

      Dir.chdir(@app_path) do
        Kernel.exec *cmd
      end
    end

    def node_modules_bin_exist?
      File.exist?("#{@node_modules_bin_path}/vite")
    end

  end
end
