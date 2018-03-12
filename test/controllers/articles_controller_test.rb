require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_article_path
    assert_response :success
    assert_template 'articles/new'
  end
end

