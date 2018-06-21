require 'test_helper'

class ColumnTest < ActiveSupport::TestCase
  setup do
    @column = columns :sample_column
  end

  test 'should be valid' do
    assert @column.valid?, @column.errors.messages
  end

  test 'should belong to an author' do
    assert_not_nil @column.author
    assert @column.valid?
    @column.author = nil
    assert_not @column.valid?
  end
end
