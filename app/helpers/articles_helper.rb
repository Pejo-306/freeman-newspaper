module ArticlesHelper
  include ApplicationHelper

  # Heuristically evaluate the relevancy of an article
  def heuristic_article_value(article)
    # the relevancy of an article is calculated via the following formula:
    # = e^(log10(<article.views>)^2) - e^(<Time.now> - <article.created_at> as days)
    Math.exp(Math.log10(article.views)**2) -
      Math.exp(time_diff(Time.zone.now, article.created_at, format: 'days'))
  end
end

