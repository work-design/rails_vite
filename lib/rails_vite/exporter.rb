require_relative 'yaml'
require 'active_support/core_ext/pathname/existence'

module RailsVite
  module Exporter
    extend self

    def export
      vite = Yaml.new(template: 'config/vite_template.yml', export: 'config/vite.yml')

      vite.append 'entry_paths', Rails.root.join('app/views').to_s
      vite.append 'entry_paths', Rails.root.join('app/entrypoints').to_s
      vite.add 'alias', { 'rails' => Rails.root.join('app/assets').to_s }
      Rails::Engine.subclasses.each do |engine|
        asset_root = engine.root.join('app/assets')
        if asset_root.directory?
          vite.add 'alias', { "#{engine.engine_name}_ui" => asset_root.to_s }
        end

        vue_root = engine.root.join('app/vue')
        if vue_root.directory?
          vite.add 'alias', { "#{engine.engine_name}_vue" => vue_root.to_s }
        end

        view_root = engine.root.join('app/views')
        if view_root.directory?
          vite.append 'entry_paths', view_root.to_s
          vite.add 'alias', { "#{engine.engine_name}_view" => view_root.to_s }
        end

        entrypoint_root = engine.root.join('app/assets', 'entrypoints')
        if entrypoint_root.directory?
          vite.append 'entry_paths', entrypoint_root.to_s
        end

        # 为每个 engine 运行 yarn install
        if engine.root.join('yarn.lock').exist?
          Dir.chdir engine.root do
            $stdout.puts "\e[35minstall\e[0m #{engine.root}"
            system 'yarn install'
          end
        end
      end

      vite.dump
    end

  end
end
