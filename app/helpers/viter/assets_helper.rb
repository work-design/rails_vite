# frozen_string_literal: true
module Viter
  module AssetsHelper

    # Assets path: app/assets/javascripts/controllers
    def pack_path(ext:, **options)
      path, ext = assets_load_path(ext: ext, suffix: options.delete(:suffix))

      asset_vite_path(path + ext)
    end

    def js_load(ext: '.js', **options)
      path, _ = assets_load_path(ext: ext, suffix: options.delete(:suffix))
      options[:host] = Viter.instance.config.host if dev_host?

      if path
        javascript_include_tag("/#{path}", type: 'module', **options)
      end
    end

    # Assets path: app/assets/stylesheets/controllers
    def css_load(ext: '.scss', **options)
      path, _ = assets_load_path(ext: ext, suffix: options.delete(:suffix))
      options[:host] = Viter.instance.config.host if dev_host?

      if path
        stylesheet_link_tag("/#{path}", extname: ext, **options)
      end
    end

    private
    def assets_load_path(ext: '.js', suffix: nil, separator: '-')
      filename = "#{controller_path}/#{@_rendered_template}"
      filename = [filename, suffix].join(separator) if suffix

      pathname = Pathname.new(@_rendered_template_path)
      asset_name = pathname.without_extname.sub_ext ext
      r = Viter.manifest.lookup_by_path(asset_name)

      if r
        [r, ext]
      else
        []
      end
    end

    def dev_host?
      Rails.env.development? && !Viter.instance.manifest.exist?
    end

  end
end
