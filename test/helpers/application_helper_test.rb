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
end

