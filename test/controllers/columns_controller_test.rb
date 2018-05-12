require 'test_helper'

class ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @column = columns :sample_column
  end

  test 'should get show' do
    get column_path(@column)
    assert_response :success
    assert_template 'columns/show'
  end
end

