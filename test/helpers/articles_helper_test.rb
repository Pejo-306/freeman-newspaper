require 'test_helper'

class ArticlesHelperTest < ActionView::TestCase
  setup do
    @article = articles :sample_article
    @recent_articles = Article.where(content: "I'm a recent article")
  end

  test 'should calculate the heuristic value of an article' do
    @article.views = 100
    @article.created_at = 1.days.ago
    assert_includes 53.5..53.75, heuristic_article_value(@article)
  end

  test 'should return the most relevant articles' do
    article_subset = most_relevant_articles @recent_articles, num: 3, max_days: 30
    last_3_articles = Article.where(content: "I'm a recent article")
                        .order('created_at DESC').first 3
    article_subset.each { |article| assert_includes last_3_articles, article }
  end

  test 'should return an empty relation if there are no recent articles' do
    article_subset = most_relevant_articles @recent_articles, num: 3, max_days: 0
    assert_equal 0, article_subset.count
  end
end

