require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'should return the current year' do
    travel_to Date.new(2018, 1, 1) do
      assert_equal 2018, current_year
    end 
  end

  test "should provide the site's base title when no page title is given" do
    assert_equal "The Freeman's newspaper", site_title
  end

  test "should provide the site's full title" do
    assert_equal "The Freeman's newspaper | About", site_title('About')
  end

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

