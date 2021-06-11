# frozen_string_literal: true

# Public: Allows to render HTML tags for scripts and styles processed by Vite.

module Ui
  module ViterHelper

    def image_vite_tag(name, **options)
      if Rails.env.development?
        image_tag(name, **options)
      else
        r = path_to_image(name)
        r = r.delete_prefix('/')
        mani = vite_manifest.find(r)
        if mani
          image_tag("/#{mani['assets'][0]}", **options)
        end
      end
    end

    # Public: Resolves the path for the specified Vite asset.
    #
    # Example:
    #   <%= vite_asset_path 'calendar.css' %> # => "/vite/assets/calendar-1016838bab065ae1e122.css"
    def asset_vite_path(name, **options)
      asset_path name, options
    end

    def image_vite_path(name, **options)
      image_path(name, options)
    end

    # Public: Renders a <script> tag for the specified Vite entrypoints.
    def javascript_vite_tag(*names, type: 'module', crossorigin: 'anonymous', **options)
      if Rails.env.development?
        entries = names
        options[:host] = Viter.instance.config.host
      else
        entries = names.map do |name|
          r = path_to_javascript(name)
          r.delete_prefix!('/')
          mani = vite_manifest.find(r)
          if mani
            "/#{mani['file']}"
          end
        end.compact
      end

      if entries.blank?
        logger.debug "Names: #{names}"
      else
        javascript_include_tag(*entries, crossorigin: crossorigin, type: type, **options)
      end
    end

    # Public: Renders a <script> tag for the specified Vite entrypoints.
    def typescript_vite_tag(*names, **options)
      vite_javascript_tag(*names, asset_type: :typescript, **options)
    end

    # Public: Renders a <link> tag for the specified Vite entrypoints.
    def stylesheet_vite_tag(*names, **options)
      unless Rails.env.development?
        entries = names.map do |name|
          r = path_to_javascript(name)
          r.delete_prefix!('/')
          mani = vite_manifest.find(r)
          if mani
            csses = []
            csses += mani.fetch('css', []).map(&->(i){ "/#{i}" })
            mani.fetch('imports', []).map(&->(i){
              csses += vite_manifest.find_css(i)
            })
            csses
          end
        end.flatten.compact

        stylesheet_link_tag(*entries, **options)
      end
    end

    private
    def vite_manifest
      Viter.instance.manifest
    end

    # Internal: Renders a modulepreload link tag.
    def vite_preload_tag(*sources, crossorigin:, **options)
      sources.map { |source|
        href = path_to_asset(source)
        try(:request).try(:send_early_hints, 'Link' => %(<#{ href }>; rel=modulepreload; as=script; crossorigin=#{ crossorigin }))
        tag.link(rel: 'modulepreload', href: href, as: 'script', crossorigin: crossorigin, **options)
      }.join("\n").html_safe
    end

  end
end
