require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:sample_article)
  end

  test 'should get show' do
    get article_path(@article)
    assert_response :success
    assert_template 'articles/show'
  end

  test 'should get new' do
    get new_article_path
    assert_response :success
    assert_template 'articles/new'
  end

  test 'should get edit' do
    get edit_article_path(@article)
    assert_response :success
    assert_template 'articles/edit'
  end

  test 'should create a new article when valid information is posted' do
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Hello World',
                                              content: 'Sample content' } }
    end
    assert_response :redirect
  end

  test 'should not create a new article when invalid information is posted' do
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: '',
                                              content: '' } }
    end
    assert_template 'articles/new'
  end

  test 'should not update article when invalid information is posted' do
    title = @article.title
    content = @article.content
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: '',
                     content: '' }
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_template 'articles/edit'
  end

  test 'should update article when valid information is posted' do
    travel 1.hours do
      assert_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'Hello World',
                     content: 'Sample content' }
        }
      end
    end
    @article.reload
    assert_equal 'Hello World', @article.title
    assert_equal 'Sample content', @article.content
    assert_response :redirect
  end

  test 'should delete article' do
    assert_difference 'Article.count', -1 do
      delete article_path(@article)
    end
    assert_response :redirect
  end
end

