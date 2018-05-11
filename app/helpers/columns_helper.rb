module ColumnsHelper
  # Return the column record of the currently logged-in author
  def current_column
    Column.find_by_author_id(current_author) unless current_author.nil?
  end
end

