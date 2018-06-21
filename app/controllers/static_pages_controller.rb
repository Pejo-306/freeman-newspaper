class StaticPagesController < ApplicationController
  def home
    @articles = most_relevant_articles Article.all, num: 8, max_days: 30
    @topics = Topic.order('RANDOM()').limit 7
    @columns = most_relevant_columns Column.all, num: 7, max_days: nil
  end

  def about
  end
end

