require_relative 'yaml'

module Viter
  module Exporter
    extend self

    def export
      vite = Yaml.new(template: 'config/viter_template.yml', export: 'config/viter.yml')

      Rails::Engine.subclasses.each do |engine|
        asset_root = engine.root.join('app/assets')
        if asset_root.directory?
          vite.add 'alias', { "#{engine.engine_name}_ui" => asset_root.to_s }
        end

        view_root = engine.root.join('app/views')
        if view_root.directory?
          vite.append 'entry_paths', view_root.to_s
          vite.add 'alias', { "#{engine.engine_name}_view" => view_root.to_s }
        end

        entrypoint_root = engine.root.join('app/assets', 'entrypoints')
        if entrypoint_root.directory?
          vite.append 'entry_paths', entrypoint_root
        end
      end

      vite.set 'base', ActionController::Base.helpers.compute_asset_host
      vite.dump
    end

  end
end
