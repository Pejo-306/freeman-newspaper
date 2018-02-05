require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'should provide the copyright notice year range' do
    travel_to Date.new(2020, 1, 1) do
      assert_equal '2020', copyright_notice_year_range(2020)
      assert_equal '2018 - 2020', copyright_notice_year_range(2018)
    end
  end
end

