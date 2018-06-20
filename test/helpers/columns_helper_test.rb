require 'test_helper'

class ColumnsHelperTest < ActionView::TestCase
  setup do
    @column = columns :sample_column
  end

  test 'should calculate the heuristic value of a column' do
    assert_includes 230..231, heuristic_column_value(@column)
  end
end

