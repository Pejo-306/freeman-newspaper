require 'test_helper'

class WebDesignHelperTest < ActionView::TestCase
  test 'should provide the needed css classes for a form label' do
    assert_equal 'col-sm-2 col-form-label', label_classes
    assert_equal 'col-sm-2 col-form-label css_class_1 css_class_2',
                 label_classes('css_class_1', 'css_class_2')
  end

  test 'should provide the needed css classes for a form submit button' do
    assert_equal 'btn btn-primary btn-block', submit_classes 
    assert_equal 'btn btn-primary btn-block css_class_1 css_class_2',
                  submit_classes('css_class_1', 'css_class_2')
    assert_equal 'btn btn-secondary btn-block',
                 submit_classes(btn_style: 'btn-secondary') 
  end

  test 'should generate a form field (without provided placeholder)' do
    expected_field =
    <<~OUTPUT
    <div class="form-group row">
      <div class="col-sm-3">
        <%= f.label :name, class: label_classes %>
      </div>
      <div class="col-sm-9">
        <%= f.text_field :name, class: 'form-control' %>
      </div>
    </div>
    OUTPUT
    assert_equal expected_field, form_field(:name, 'text_field')
  end

  test 'should generate a form field (with provided placeholder)' do
    expected_field =
    <<~OUTPUT
    <div class="form-group row">
      <div class="col-sm-3">
        <%= f.label :email, class: label_classes %>
      </div>
      <div class="col-sm-9">
        <%= f.email_field :email, class: 'form-control', placeholder: 'name@example.com' %>
      </div>
    </div>
    OUTPUT
    assert_equal expected_field, form_field(:email, 'email_field',
                                            placeholder: 'name@example.com')
  end

  test 'should generate a form check' do
    expected_check_box = 
    <<~OUTPUT
    <div class="col-sm-12">
      <div class="form-check">
        <%= f.label :admin, class: 'form-check-label' do %>
          <%= f.check_box :admin, class: 'form-check-input', value: false %>
          <span>Admin</span>
        <% end %>
      </div>
    </div>
    OUTPUT
    assert_equal expected_check_box, form_check(:admin)
  end
end

