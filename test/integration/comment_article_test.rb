require 'test_helper'

class CommentArticleTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :michael
    @article = articles :sample_article

    @comment_path = -> (column_id, article_id) do 
      URI.encode "#{article_path column_id, article_id}/comments" 
    end
  end

  test 'anonymous users should not be able to post comments' do
    get article_path(@article.column.author, @article)
    assert_template 'articles/show'
    assert_select 'p', text: 'Please, log in to post comments on this article.'
    assert_no_difference 'Comment.count' do
      post @comment_path.call(@article.column.author.id, @article.id), params: {
        id: @article.id,
        comment: { content: 'Hello World' }
      }
    end
    assert_response :redirect
    assert_redirected_to login_path
  end

  test 'should not post comments with blank content' do
    log_in_as @user
    get article_path(@article.column.author, @article)
    assert_template 'articles/show'
    assert_select 'form.new_comment'
    assert_no_difference 'Comment.count' do
      post @comment_path.call(@article.column.author.id, @article.id), params: {
        id: @article.id,
        comment: { content: '  ' }
      }
    end
    assert_response :redirect
    assert_redirected_to article_path(@article.column.author, @article)
    follow_redirect!
    assert_not flash.empty?
    assert_equal 'Invalid input data for comment', flash[:danger]
  end

  test 'should post a comment if valid data is provided' do
    log_in_as @user
    get article_path(@article.column.author, @article)
    assert_template 'articles/show'
    assert_select 'form.new_comment'
    assert_difference 'Comment.count', 1 do
      post @comment_path.call(@article.column.author.id, @article.id), params: {
        id: @article.id,
        comment: { content: "Hello, I am user #{@user.full_name}" }
      }
    end
    assert_response :redirect
    assert_redirected_to article_path(@article.column.author, @article)
    follow_redirect!
    assert_not flash.empty?
    assert_equal 'Comment has been posted', flash[:success]
    assert_select '.comment' do
      assert_select 'h5', text: "#{@user.full_name} wrote"
      assert_select 'p.comment-content', text: "Hello, I am user #{@user.full_name}"
    end
  end
end

