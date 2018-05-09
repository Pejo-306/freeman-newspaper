class ArticlesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_author_status, except: [:index, :show]

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
    if @article.author != current_author
      flash[:danger] = 'You do not have permission to alter this article ' +
                       'because you are not its author'
      redirect_to root_path
    end
  end

  def create
    @article = Article.new(article_params)
    @article.author = current_author
    if params[:topics].blank?
      # User has not associated a topic with this article
      raise ActionController::ParameterMissing.new :topics
    else
      # Take from 0 to -3 character because the topic names' string
      # ends with ', '
      topic_names = params[:topics][0..-3].split ', '
      topic_names.each do |name| 
        topic = Topic.find_by_name(name)
        raise ActionController::UnpermittedParameters.new [name] if topic.nil?
        @article.topics << Topic.find_by_name(name)
      end
    end

    if @article.save
      flash[:success] = 'Article has been posted'
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    if params[:topics].blank?
      # User has not associated a topic with this article
      raise ActionController::ParameterMissing.new :topics
    else
      # Take from 0 to -3 character because the topic names' string
      # ends with ', '
      topics = []
      topic_names = params[:topics][0..-3].split ', '
      topic_names.each do |name| 
        topic = Topic.find_by_name(name)
        raise ActionController::UnpermittedParameters.new [name] if topic.nil?
        topics << Topic.find_by_name(name)
      end
    end

    if @article.author != current_author
      flash[:danger] = 'You do not have permission to alter this article ' +
                       'because you are not its author'
      redirect_to root_url
    elsif @article.update_attributes(article_params)
      @article.topics = topics
      flash[:success] = 'Article has successfully been updated'
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    article = Article.find(params[:id])
    if article.author != current_author
      flash[:danger] = 'You do not have permission to delete this article ' +
                       'because you are not its author'
      redirect_to root_url
    else
      article.destroy
      flash[:success] = 'Article has successfully been deleted'
      redirect_to articles_path
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end
end

