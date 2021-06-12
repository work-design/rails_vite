module Viter
  module TemplateRenderer

    def render_template(view, template, layout_name, locals)
      view.instance_variable_set(:@_rendered_template_path, template.identifier)
      super
    end

  end
end

ActiveSupport.on_load :action_view do
  ActionView::TemplateRenderer.prepend Viter::TemplateRenderer
end
