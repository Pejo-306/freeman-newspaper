module WebDesignHelper
  # Return the Bootstrap 4 css classes needed to style a form label
  def label_classes(*extra_classes)
    bootstrap_classes = ['col-sm-2', 'col-form-label']
    css_classes = [*bootstrap_classes, *extra_classes]
    css_classes.join(' ')
  end

  # Return the Bootstrap 4 css classes needed to style a form submit button 
  def submit_classes(*extra_classes, btn_style: 'btn-primary')
    bootstrap_classes = ['btn', btn_style, 'btn-block']
    css_classes = [*bootstrap_classes, *extra_classes]
    css_classes.join(' ')
  end

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

