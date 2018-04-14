class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:success] = 'Article has been posted'
      redirect_to articles_url
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(article_params)
      flash[:success] = 'Article has successfully been updated'
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end
end

