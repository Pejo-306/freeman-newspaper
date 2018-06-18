class TopicsController < ApplicationController
  before_action :require_login, only: :exists

  def index
    @topics = Topic.paginate page: params[:page], per_page: 6
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @topic = Topic.find_by name: params[:name]
    topic_articles = Article.joins(:topics).where('topic_id = ?', @topic.id)
    @relevant_articles = most_relevant_articles topic_articles, num: 6, max_days: 15
    @articles = topic_articles.paginate(page: params[:page], per_page: 10)
                  .order('updated_at DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end

  def exists
    output = { exists: !Topic.find_by_name(params[:name]).nil? }
    render json: output.to_json
  end
end

