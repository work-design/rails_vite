module Viter
  class Runner

    def self.run(argv)
      $stdout.sync = true

      new(argv).run
    end

    def initialize(argv)
      @argv = argv

      @app_path = File.expand_path('.', Dir.pwd)
      @node_modules_bin_path = ENV['VITER_NODE_MODULES_BIN_PATH'] || `yarn bin`.chomp
      @vite_config = File.join(@app_path, "config/vite/#{ENV["NODE_ENV"]}.js")
      @webpacker_config = File.join(@app_path, 'config/vite.yml')

      unless File.exist?(@vite_config)
        $stderr.puts "vite config #{@vite_config} not found, please run 'bundle exec rails vite:install' to install Webpacker with default configs or add the missing config file for your custom environment."
        exit!
      end
    end

  end
end
