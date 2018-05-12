require 'test_helper'

class ArticlesUpdateTest < ActionDispatch::IntegrationTest
  setup do
    @author = authors :sample_author
    @other_author = authors :other_author
    @non_author = users :michael
    @article = articles :sample_article
    @sample_topic = topics :sample_topic
  end

  test 'attempt to access article update page as an anonymous user' do
    get edit_article_path(@article)
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
  end

  test 'attempt to access article update page as a non-author' do
    log_in_as @non_author 
    get edit_article_path(@article)
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'The account you have logged in ' +
                 'does not have author status', flash[:danger]
  end

  test "attempt to access article update page from another author's account" do
    log_in_as @other_author 
    get edit_article_path(@article)
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
    assert_equal 'You do not have permission to alter this article ' +
                 'because you are not its author', flash[:danger]
  end

  test 'attempt to alter an article as an anonymous user' do
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
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
  end

  test 'attempt to alter an article as a non-author' do
    log_in_as @non_author
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
    assert_not flash.empty?
    assert_equal 'The account you have logged in ' +
                 'does not have author status', flash[:danger]
  end

  test "attempt to alter an article from another author's account" do
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
    assert_not flash.empty?
    assert_equal 'You do not have permission to alter this article ' +
                 'because you are not its author', flash[:danger]
  end

  test 'alter an article with invalid information' do
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
    assert_select "form[action='/articles/#{@article.id}']"
    assert_select 'div#error-explanation'
  end

  test 'alter an article with valid information' do
    log_in_as @author
    travel 1.hours do
      assert_changes '@article.reload.updated_at' do
        patch article_path(@article), params: {
          article: { title: 'Hello',
                     content: 'World' },
          topics: "#{@sample_topic.name}, "
        }
      end
    end
    @article.reload
    assert_equal 'Hello', @article.title
    assert_equal 'World', @article.content
    assert_equal [@sample_topic], @article.topics
    assert_response :redirect
    assert_redirected_to article_path(@article)
    assert_not flash.empty?
    assert_equal 'Article has successfully been updated', flash[:success]
  end
end

