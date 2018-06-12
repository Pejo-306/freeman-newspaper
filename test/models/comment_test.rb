require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = users :michael
    @article = articles :sample_article
    @comment = comments :sample_comment
  end

  test 'should be valid' do
    assert @comment.valid?, "#{@comment.errors.messages}"
  end

  test 'should not be blank' do
    @comment.content = 'a'
    assert @comment.valid?
    @comment.content = ''
    assert_not @comment.valid?
    @comment.content = '' * 100
    assert_not @comment.valid?
  end

  test 'should be less than 140 characters long' do
    @comment.content = 'a' * 140
    assert @comment.valid?
    @comment.content += 'a'
    assert_not @comment.valid?
  end

  test 'should belong to a user' do
    assert_equal @user, @comment.user
    assert @comment.valid?
    @comment.user = nil
    assert_not_equal @user, @comment.user
    assert_not @comment.valid?
  end

  test 'should belong to an article' do
    assert_equal @article, @comment.article
    assert @comment.valid?
    @comment.article = nil
    assert_not_equal @article, @comment.article
    assert_not @comment.valid?
  end
end

