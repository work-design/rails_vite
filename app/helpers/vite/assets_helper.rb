# frozen_string_literal: true
module Vite
  module AssetsHelper

    # Assets path: app/assets/javascripts/controllers
    def pack_path(ext:, **options)
      path, ext = assets_load_path(ext: ext, suffix: options.delete(:suffix))

      asset_vite_path(path + ext)
    end

    def js_load(ext: '.js', **options)
      path, _ = assets_load_path(ext: ext, suffix: options.delete(:suffix))
      options[:host] = RailsVite.instance.config.host if dev_host?

      if path
        javascript_include_tag("/#{path}", type: 'module', **options)
      end
    end

    # Assets path: app/assets/stylesheets/controllers
    def css_load(ext: '.scss', **options)
      path, _ = assets_load_path(ext: ext, suffix: options.delete(:suffix))
      options[:host] = RailsVite.instance.config.host if dev_host?

      if path
        stylesheet_link_tag("/#{path}", extname: ext, **options)
      end
    end

    private
    def assets_load_path(ext: '.js', suffix: nil, separator: '-')
      filename = "#{controller_path}/#{@_rendered_template}"
      filename = [filename, suffix].join(separator) if suffix
      filename = "#{filename}#{ext}"

      #pathname = Pathname.new(@_rendered_template_path)
      #asset_name = pathname.without_extname.sub_ext ext
      r = RailsVite.manifest.find(filename)

      if r
        [r['file'], ext]
      else
        []
      end
    end

    def dev_host?
      Rails.env.development? && !RailsVite.instance.manifest.exist?
    end

  end
end
