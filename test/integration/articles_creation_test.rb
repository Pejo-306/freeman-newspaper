require 'test_helper'

class ArticlesCreationTest < ActionDispatch::IntegrationTest
  setup do
    @author = users(:sample_author)
    @non_author = users(:michael)
    @sample_topic = topics(:sample_topic)
  end

  test 'attempt to access article creation page as an anonymous user' do
    get new_article_path
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
  end

  test 'attempt to access article creation page as a non-author' do
    log_in_as @non_author 
    get new_article_path
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'The account you have logged in ' +
                 'does not have author status', flash[:danger]
  end

  test 'attempt to post an article as an anonymous user' do
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: 'valid',
                                               content: 'information' }, 
                                    topics: "#{@sample_topic.name}, " }
    end
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
  end

  test 'attempt to post an articles as a non-author' do
    log_in_as @non_author
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: 'valid',
                                               content: 'information' },
                                    topics: "#{@sample_topic.name}, " }
    end
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'The account you have logged in ' +
                 'does not have author status', flash[:danger]
  end

  test 'post an articles as an author with invalid information' do
    log_in_as @author
    get new_article_path
    assert_response :success
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: 'Invalid info',
                                               content: '' },
                                    topics: "#{@sample_topic.name}, " }
    end
    assert_template 'articles/new'
    assert_select 'form[action="/articles"]'
    assert_select 'div#error-explanation'
  end

  test 'post an articles as an author with valid information' do
    log_in_as @author
    get new_article_path
    assert_response :success
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Unique this title it is',
                                               content: 'And so is this content' },
                                    topics: "#{@sample_topic.name}, " }
    end
    article = Article.last
    assert_equal 'Unique this title it is', article.title
    assert_equal 'And so is this content', article.content
    assert_equal @author.id, article.column.author.id
    assert_response :redirect
    assert_redirected_to articles_path
    assert_not flash.empty?
    assert_equal 'Article has been posted', flash[:success]
  end
end

