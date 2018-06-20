module ArticlesHelper
  include ApplicationHelper

  # Heuristically evaluate the relevancy of an article
  def heuristic_article_value(article)
    # the relevancy of an article is calculated via the following formula:
    # = e^(log10(<article.views>)^2) - e^(<Time.now> - <article.created_at> as days)
    Math.exp(Math.log10(article.views+1)**2) -
      Math.exp(time_diff(Time.zone.now, article.created_at, format: 'days') / 1.5)
  end

  # Pick a number of the most relevant articles
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

  # Prevent authors from posting more than once a day
  def check_last_post_date
    if logged_in?
      return if current_author.column.articles.count == 0
      last_post_date = current_author.column.articles.last.created_at
      time_delta = time_diff Time.zone.now, last_post_date, format: 'hours'
      if time_delta < 24  # author has attempted to post in less than 24 hours
        flash[:danger] = "You can only post one article per day " +
                         "(#{24 - time_delta.round} hours left)"
        redirect_to articles_path(current_author)
      end
    end
  end
end

