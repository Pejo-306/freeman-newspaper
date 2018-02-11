module StaticPagesHelper
  # Render a hyperlink as a breadcrumb item
  def breadcrumb_item(text, path)
    if path == request.env['PATH_INFO']
      content = text
      css_classes = 'breadcrumb-item active'
    else
      content = link_to text, path
      css_classes = 'breadcrumb-item'
    end
    content_tag(:li, content, class: css_classes)
  end
end

