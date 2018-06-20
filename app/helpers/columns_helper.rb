module ColumnsHelper
  # Return the column record of the currently logged-in author
  def current_column
    Column.find_by_author_id(current_author) unless current_author.nil?
  end

  # Heuristically evaluate the relevancy of a column
  def heuristic_column_value(column)
    Math.exp(Math.log10(column.articles.sum('views')+1) ** 1.5)
  end
end

