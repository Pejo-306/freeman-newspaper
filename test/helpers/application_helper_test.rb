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
    assert_equal "About | The Freeman's newspaper", site_title('About')
  end

  test 'should return a form field type when passed either a string or a symbol' do
    assert_equal 'text_field', get_form_field_type(:string)
    assert_equal 'text_field', get_form_field_type('string')

    attribute_types = [:string, :integer]
    attribute_types.each do |type|
      assert_not_nil get_form_field_type(type)
      assert_not_nil get_form_field_type(type.to_s)
    end
  end

  test 'should return the form field type which corresponds to the column type' do
    assert_equal 'text_field', get_form_field_type(:string)
    assert_equal 'number_field', get_form_field_type(:integer)
  end
end

