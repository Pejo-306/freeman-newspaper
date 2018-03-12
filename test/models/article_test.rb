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
end
