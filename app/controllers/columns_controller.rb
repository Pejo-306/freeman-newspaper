class ColumnsController < ApplicationController
  def show
    author_name, author_surname = params[:author_name].downcase.split
    @author = Author.where('lower(name) = ? AND lower(surname) = ?', 
                           author_name, author_surname).first
    # Display a 404 error page for non-existent records
    raise ActiveRecord::RecordNotFound if @author.nil?
    @column = @author.column
  end
end

