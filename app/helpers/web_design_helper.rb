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

  # Render a form field
  def form_field(field, field_type, placeholder: nil)
    erb_label = "<%= f.label :#{field}, class: label_classes %>"
    erb_field = "<%= f.#{field_type} :#{field}, class: 'form-control'"
    erb_field += ", placeholder: '#{placeholder}'" unless placeholder.nil?
    erb_field += ' %>'
    
    <<~FORM_FIELD
    <div class="form-group row">
      <div class="col-sm-3">
        #{erb_label}
      </div>
      <div class="col-sm-9">
        #{erb_field}
      </div>
    </div>
    FORM_FIELD
  end

  # Render a form radio button
  def form_check(field)
    <<~FORM_CHECK
    <div class="col-sm-12">
      <div class="form-check">
        <%= f.label :#{field}, class: 'form-check-label' do %>
          <%= f.check_box :#{field}, class: 'form-check-input', value: false %>
          <span>#{field.capitalize}</span>
        <% end %>
      </div>
    </div>
    FORM_CHECK
  end
end

