# Singleton registry for accessing the packs path using a generated manifest.
# This allows javascript_pack_tag, stylesheet_pack_tag, asset_pack_path to take a reference to,
# say, "calendar.js" or "calendar.css" and turn it into "/packs/calendar-1016838bab065ae1e314.js" or
# "/packs/calendar-1016838bab065ae1e314.css".
#
# When the configuration is set to on-demand compilation, with the `compile: true` option in
# the viter.yml file, any lookups will be preceded by a compilation if one is needed.
module Viter
  class Manifest
    class MissingEntryError < StandardError; end

    delegate :config, :compiler, :dev_server, to: :@viter
    attr_reader :viter

    def initialize(viter)
      @viter = viter
    end

    def refresh
      @data = load
    end

    def lookup_pack_with_chunks(name, pack_type = {})
      compile if compiling?

      manifest_pack_type = manifest_type(pack_type[:type])
      manifest_pack_name = manifest_name(name, manifest_pack_type)
      find('entrypoints')[manifest_pack_name]['assets'][manifest_pack_type]
    rescue NoMethodError
      nil
    end

    def lookup_pack_with_chunks!(name, pack_type = {})
      lookup_pack_with_chunks(name, pack_type) || handle_missing_entry(name, pack_type)
    end

    # Computes the relative path for a given Viter asset using manifest.json.
    # If no asset is found, returns nil.
    #
    # Example:
    #
    #  Viter.manifest.lookup('calendar.js') # => "/packs/calendar-1016838bab065ae1e122.js"
    def lookup(name, pack_type = {})
      compile if compiling?

      find(full_pack_name(name, pack_type[:type]))
    end

    # Like lookup, except that if no asset is found, raises a Webpacker::Manifest::MissingEntryError.
    def lookup!(name, pack_type = {})
      lookup(name, pack_type) || handle_missing_entry(name, pack_type)
    end

    def lookup_by_path(path)
      relative_path = path.relative_path_from config.source_path

      find(relative_path)
    end

    def compiling?
      config.compile? && !dev_server.running?
    end

    def compile
      Viter.logger.tagged('Viter') { compiler.compile }
    end

    def data
      if config.cache_manifest?
        @data ||= load
      else
        refresh
      end
    end

    def find(name)
      data[name.to_s].presence
    end

    def find_css(name)
      r = find(name)
      Array(r['css']).map(&->(i){ "/#{i}" })
    end

    def full_pack_name(name, pack_type)
      return name unless File.extname(name.to_s).empty?
      "#{name}.#{manifest_type(pack_type)}"
    end

    def handle_missing_entry(name, pack_type)
      raise Manifest::MissingEntryError, missing_file_from_manifest_error(full_pack_name(name, pack_type[:type]))
    end

    def load
      if config.public_manifest_path.exist?
        JSON.parse config.public_manifest_path.read
      else
        {}
      end
    end

    # The `manifest_name` method strips of the file extension of the name, because in the
    # manifest hash the entrypoints are defined by their pack name without the extension.
    # When the user provides a name with a file extension, we want to try to strip it off.
    def manifest_name(name, pack_type)
      return name if File.extname(name.to_s).empty?
      File.basename(name, ".#{pack_type}")
    end

    def manifest_type(pack_type)
      case pack_type
      when :javascript then 'js'
      when :stylesheet then 'css'
      else pack_type.to_s
      end
    end

  end
end
