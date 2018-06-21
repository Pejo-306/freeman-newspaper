require 'test_helper'

class ColumnsHelperTest < ActionView::TestCase
  setup do
    @column = columns :sample_column
  end

  test 'should calculate the heuristic value of a column' do
    assert_includes 230..231, heuristic_column_value(@column)
  end

  test 'should return an empty relation if there are no recent columns' do
    column_subset = most_relevant_columns Column.all, num: 4, max_days: 0
    assert_equal 0, column_subset.count
  end
end

