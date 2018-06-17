require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles :sample_article
    @author = authors :sample_author
    @other_author = authors :other_author
    @normal_user = users :michael
    @sample_topic = topics :sample_topic

    @comment_path = -> (article_id) { URI.encode "#{article_path article_id}/comments" }
    @add_view_path = -> (article_id) { URI.encode "#{article_path article_id}/add-view" }
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
      post articles_path, params: { article: { title: 'Hello World',
                                               content: 'Sample Content' },
                                    topics: "#{@sample_topic.name}, " }
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not create a new article when logged in as a non-author' do
    log_in_as @normal_user
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: 'Hello World',
                                               content: 'Sample Content' },
                                    topics: "#{@sample_topic.name}, " }
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should create a new article when valid information is posted' do
    log_in_as @author
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Hello World',
                                               content: 'Sample content' },
                                    topics: "#{@sample_topic.name}, " }
    end
    assert_response :redirect
  end

  test 'should not create a new article when invalid information is posted' do
    log_in_as @author
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: '',
                                               content: '' },
                                    topics: "#{@sample_topic.name}, " }
    end
    assert_template 'articles/new'
  end
  
  test 'should raise an error if the topics parameter is missing on article creation' do
    log_in_as @author
    assert_raises ActionController::ParameterMissing do
      post articles_path, params: { article: { title: 'Hello World',
                                               content: 'Sample Content' },
                                    topics: '' }
    end
  end

  test 'should raise an error if the topics parameter contains a non-existent topic on article creation' do
    log_in_as @author
    assert_raises ActionController::UnpermittedParameters do
      post articles_path, params: { article: { title: 'Hello World',
                                               content: 'Sample Content' },
                                    topics: 'something very invalid, ' }
    end
  end

  test 'should not update article when not logged in' do
    title = @article.title
    content = @article.content
    topics = @article.topics
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'invalid',
                     content: 'invalid' },
          topics: topics.map { |topic| topic.name }.join(', ') + ', '
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_equal topics, @article.topics
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not update article when logged in as a non-author' do
    log_in_as @normal_user
    title = @article.title
    content = @article.content
    topics = @article.topics
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'invalid',
                     content: 'invalid' },
          topics: topics.map { |topic| topic.name }.join(', ') + ', '
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_equal topics, @article.topics
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not update article when logged in as an author who is not the owner of the article' do
    log_in_as @other_author
    title = @article.title
    content = @article.content
    topics = @article.topics
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'invalid',
                     content: 'invalid' },
          topics: topics.map { |topic| topic.name }.join(', ') + ', '
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_equal topics, @article.topics
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should not update article when invalid information is posted' do
    log_in_as @author
    title = @article.title
    content = @article.content
    topics = @article.topics
    travel 1.hours do
      assert_no_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: '',
                     content: '' },
          topics: topics.map { |topic| topic.name }.join(', ') + ', '
        }
      end
    end
    @article.reload
    assert_equal title, @article.title
    assert_equal content, @article.content
    assert_equal topics, @article.topics
    assert_template 'articles/edit'
  end

  test 'should update article when valid information is posted' do
    log_in_as @author
    travel 1.hours do
      assert_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'Hello World',
                     content: 'Sample content' }, 
          topics: "#{@sample_topic.name}, "
        }
      end
    end
    @article.reload
    assert_equal 'Hello World', @article.title
    assert_equal 'Sample content', @article.content
    assert_equal [@sample_topic], @article.topics
    assert_response :redirect
  end

  test 'should raise an error if the topics parameter is missing on article update' do
    log_in_as @author
    assert_raises ActionController::ParameterMissing do
      patch article_path(@article), params: {
        article: { title: 'Hello World',
                   content: 'Sample Content' },
        topics: ''
      }
    end
  end

  test 'should raise an error if the topics parameter contains a non-existent topic on article update' do
    log_in_as @author
    assert_raises ActionController::UnpermittedParameters do
      patch article_path(@article), params: {
        article: { title: 'Hello World',
                  content: 'Sample Content' },
        topics: 'something very invalid, '
      }
    end
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

  test 'should not create a comment if the user is not logged in' do
    assert_no_difference 'Comment.count' do
      post @comment_path.call(@article.id), params: {
        id: @article.id,
        comment: { content: 'Hello World' }
      }
    end
  end

  test 'should not create a comment if invalid data is posted' do
    log_in_as @normal_user
    assert_no_difference 'Comment.count' do
      post @comment_path.call(@article.id), params: {
        id: @article.id,
        comment: { content: '  ' }
      }
    end
  end

  test 'should create a comment if valid data is posted' do
    log_in_as @normal_user
    assert_difference 'Comment.count', 1 do
      post @comment_path.call(@article.id), params: {
        id: @article.id,
        comment: { content: 'Hello World' }
      }
    end
  end

  test 'should increment the view counter' do
    assert_difference '@article.reload.views', 1 do
      get @add_view_path.call(@article.id)
    end
  end

  test "should not change the 'updated_at' time stamp when incrementing the view counter" do
    assert_no_difference '@article.reload.updated_at' do
      get @add_view_path.call(@article.id)
    end
  end

  test 'should not display any content when incrementing the view counter' do
      get @add_view_path.call(@article.id)
      assert_response 204 
  end
end

