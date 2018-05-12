require 'test_helper'

class ArticlesDeletionTest < ActionDispatch::IntegrationTest
  setup do
    @author = authors :sample_author
    @other_author = authors :other_author
    @non_author = users :michael
    @article = articles :sample_article
  end

  test 'attempt to delete an article as an anonymous user' do
    assert_no_difference 'Article.count' do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
  end

  test 'attempt to delete an article as a non-author user' do
    log_in_as @non_author
    assert_no_difference 'Article.count' do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'The account you have logged in ' +
                 'does not have author status', flash[:danger]
  end

  test "attempt to delete an article from another author's" do
    log_in_as @other_author
    assert_no_difference 'Article.count' do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
    assert_equal 'You do not have permission to delete this article ' +
                 'because you are not its author', flash[:danger]
  end

  test 'delete an article' do
    log_in_as @author
    assert_difference 'Article.count', -1 do
      delete article_path(@article)
    end
    assert_response :redirect
    assert_redirected_to articles_path
  end
end

