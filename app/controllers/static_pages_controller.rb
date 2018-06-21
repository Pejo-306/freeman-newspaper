class StaticPagesController < ApplicationController
  def home
    @articles = most_relevant_articles Article.all, num: 8, max_days: 30
    @topics = Topic.order('RANDOM()').limit 7
  end

  def about
  end
end

