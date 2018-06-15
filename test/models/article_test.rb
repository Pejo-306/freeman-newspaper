require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  setup do
    @article = articles(:sample_article)
  end

  test 'should be valid' do
    assert @article.valid?
  end

  test 'title should be present' do
    @article.title = ''
    assert @article.invalid?, 'Title is not present'
  end

  test 'title should be no longer than 100 characters long' do
    @article.title = 'a' * 100
    assert @article.valid?
    @article.title += 'a'
    assert @article.invalid?, 'Title is longer than 100 characters'
  end

  test 'content should be present' do
    @article.content = ''
    assert @article.invalid?, 'Content is not present'
  end

  test 'views count should be present' do
    assert @article.valid?
    @article.views = nil
    assert_not @article.valid?
  end

  test 'should initialize the views count as 0' do
    article = Article.new
    assert_equal 0, article.views
  end

  test 'views count should be non-negative' do
    @article.views = -1
    assert_not @article.valid?
    @article.views = 0
    assert @article.valid?
    @article.views = 1
    assert @article.valid?
  end

  test 'should belong to a column' do
    assert_not_nil @article.column
    assert @article.valid?
    @article.column = nil
    assert_not @article.valid?
  end
end
