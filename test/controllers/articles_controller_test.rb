require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:sample_article)
    @author = users(:sample_author)
    @other_author = users(:other_author)
    @normal_user = users(:michael)
  end

  test 'should get show' do
    get article_path(@article)
    assert_response :success
    assert_template 'articles/show'
  end

  test 'should not get new when not logged in' do
    get new_article_path
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not get new when logged in as a non-author' do
    log_in_as @normal_user
    get new_article_path
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should get new when logged in as an author' do
    log_in_as @author
    get new_article_path
    assert_response :success
    assert_template 'articles/new'
  end

  test 'should not get edit when not logged in' do
    get edit_article_path(@article)
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not get edit when logged in as a non-author' do
    log_in_as @normal_user
    get edit_article_path(@article)
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not get edit when logged in as an author who is not the owner of the article' do
    log_in_as @other_author
    get edit_article_path(@article)
    assert_response :redirect
    assert_redirected_to root_url 
  end

  test 'should get edit when logged in as the author of the article' do
    log_in_as @author
    get edit_article_path(@article)
    assert_response :success
    assert_template 'articles/edit'
  end

  test 'should not create a new article when not logged in' do
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: '',
                                               content: '' } }
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not create a new article when logged in as a non-author' do
    log_in_as @normal_user
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: '',
                                               content: '' } }
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should create a new article when valid information is posted' do
    log_in_as @author
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Hello World',
                                               content: 'Sample content' } }
    end
    assert_response :redirect
  end

  test 'should not create a new article when invalid information is posted' do
    log_in_as @author
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: '',
                                               content: '' } }
    end
    assert_template 'articles/new'
  end

  test 'should not update article when not logged in' do
    title = @article.title
    content = @article.content
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'invalid',
                     content: 'invalid' }
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not update article when logged in as a non-author' do
    log_in_as @normal_user
    title = @article.title
    content = @article.content
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'invalid',
                     content: 'invalid' }
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not update article when logged in as an author who is not the owner of the article' do
    log_in_as @other_author
    title = @article.title
    content = @article.content
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'invalid',
                     content: 'invalid' }
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should not update article when invalid information is posted' do
    log_in_as @author
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
    log_in_as @author
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

  test 'should not delete article when not logged in' do
    assert_no_difference 'Article.count' do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not delete article when logged in as a non-author' do
    log_in_as @normal_user
    assert_no_difference 'Article.count' do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not delete article when logged in as an author who is not the owner of the article' do
    log_in_as @other_author
    assert_no_difference 'Article.count' do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should delete article when logged in as author of the article' do
    log_in_as @author
    assert_difference 'Article.count', -1 do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to articles_path
  end
end

