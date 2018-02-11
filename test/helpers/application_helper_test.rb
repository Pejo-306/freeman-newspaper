require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'should return the current year' do
    travel_to Date.new(2018, 1, 1) do
      assert_equal 2018, current_year
    end 
  end

  test 'should provide the needed css classes for a form label' do
    assert_equal 'col-sm-2 col-form-label', label_classes
    assert_equal 'col-sm-2 col-form-label css_class_1 css_class_2',
                 label_classes('css_class_1', 'css_class_2')
  end

  test 'should provide the needed css classes for a form submit button' do
    assert_equal 'btn btn-block', submit_classes 
    assert_equal 'btn btn-block btn-primary', submit_classes('btn-primary')
  end
end

