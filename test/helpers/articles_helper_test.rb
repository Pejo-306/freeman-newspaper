require 'test_helper'

class ArticlesHelperTest < ActionView::TestCase
  setup do
    @article = articles :sample_article
  end

  test 'should calculate the heuristic value of an article' do
    @article.views = 100
    @article.created_at = 1.days.ago
    assert_includes 51.8..52, heuristic_article_value(@article)
  end
end

