class ColumnsController < ApplicationController
  def index
    @columns = Column.paginate page: params[:page], per_page: 8
    @recently_relevant_columns = most_relevant_columns Column.all

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @author = Author.find params[:author_id]
    # Display a 404 error page for non-author user ids
    raise ActiveRecord::RecordNotFound unless @author.author?
    @column = @author.column
    @relevant_articles = most_relevant_articles @column.articles 
    @articles = @column.articles.paginate(page: params[:page], per_page: 10)
                  .order('updated_at DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end
end

