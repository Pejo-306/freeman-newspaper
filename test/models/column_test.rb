require 'test_helper'

class ColumnTest < ActiveSupport::TestCase
  setup do
    @sample_column = columns(:sample_column)
  end

  test 'should be valid' do
    assert @sample_column.valid?
  end
end
