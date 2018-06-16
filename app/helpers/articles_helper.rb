module ArticlesHelper
  include ApplicationHelper

  # Heuristically evaluate the relevancy of an article
  def heuristic_article_value(article)
    # the relevancy of an article is calculated via the following formula:
    # = e^(log10(<article.views>)^2) - e^(<Time.now> - <article.created_at> as days)
    Math.exp(Math.log10(article.views)**2) -
      Math.exp(time_diff(Time.zone.now, article.created_at, format: 'days') / 1.5)
  end

  def most_relevant_articles(articles, num: 3, max_days: 30)
    # retrieve only the newest articles
    article_subset = articles.where('created_at > :start_date',
                                    { start_date: Time.zone.now - max_days.days })

    # calculate the heuristic values for each article of the subset
    heuristic_values = {}
    article_subset.each do |article| 
      heuristic_values[heuristic_article_value(article)] = article.id
    end
    
    # select only the top rated 'num' of articles
    selected_article_ids = []
    num.times do |_|
      heuristic_key = heuristic_values.keys.max
      selected_article_ids << heuristic_values[heuristic_key]
      heuristic_values.delete heuristic_key
    end
    article_subset.find selected_article_ids
  end
end

