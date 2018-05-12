class ColumnsController < ApplicationController
  def show
    @column = Column.find params[:id]
  end
end

