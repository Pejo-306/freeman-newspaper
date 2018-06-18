module ArticlesHelper
  include ApplicationHelper

  # Heuristically evaluate the relevancy of an article
  def heuristic_article_value(article)
    # the relevancy of an article is calculated via the following formula:
    # = e^(log10(<article.views>)^2) - e^(<Time.now> - <article.created_at> as days)
    Math.exp(Math.log10(article.views+1)**2) -
      Math.exp(time_diff(Time.zone.now, article.created_at, format: 'days') / 1.5)
  end

  def most_relevant_articles(articles, num: 3, max_days: 30)
    # retrieve only the newest articles
    article_subset = articles.where('articles.created_at > :start_date',
                                    { start_date: max_days.days.ago })

    # heuristically evaluate each retrieved article
    heuristic_values = []
    article_ids = []
    article_subset.each do |article|
      heuristic_values << heuristic_article_value(article)
      article_ids << article.id
    end
    
    # select only the top rated 'num' of articles
    selected_article_ids = []
    num.times do |_|
      break if heuristic_values.empty?
      heuristic_index = heuristic_values.index heuristic_values.max
      selected_article_ids << article_ids[heuristic_index]
      heuristic_values.delete_at heuristic_index
      article_ids.delete_at heuristic_index
    end
    !selected_article_ids.empty? ? article_subset.find(selected_article_ids) : Article.none
  end
end

