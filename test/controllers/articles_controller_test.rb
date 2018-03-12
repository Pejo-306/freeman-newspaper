require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:sample_article)
  end

  test 'should get new' do
    get new_article_path
    assert_response :success
    assert_template 'articles/new'
  end

  test 'should get show' do
    get article_path(@article)
    assert_response :success
    assert_template 'articles/show'
  end
end

