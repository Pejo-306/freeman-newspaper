require 'test_helper'

class ColumnTest < ActiveSupport::TestCase
  setup do
    @column = columns :sample_column
  end

  test 'should be valid' do
    assert @column.valid?, @column.errors.messages
  end

  test 'heuristic_value should be present' do
    assert_not_nil @column.heuristic_value
    assert @column.valid?
    @column.heuristic_value = nil
    assert_nil @column.heuristic_value
    assert_not @column.valid?
  end

  test 'should belong to an author' do
    assert_not_nil @column.author
    assert @column.valid?
    @column.author = nil
    assert_not @column.valid?
  end

  test 'should set defaults' do
    new_column = Column.new
    assert_equal 0, new_column.heuristic_value
  end
end
