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
end

