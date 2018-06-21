module ColumnsHelper
  # Return the column record of the currently logged-in author
  def current_column
    Column.find_by_author_id(current_author) unless current_author.nil?
  end

  # Heuristically evaluate the relevancy of a column
  def heuristic_column_value(column)
    Math.exp(Math.log10(column.articles.sum('views')+1) ** 1.5)
  end

  # Pick a number of the most relevant columns
  def most_relevant_columns(columns, num: 4, max_days: 30)
    # retrieve only the newest columns
    column_subset = columns.where('columns.created_at > :start_date',
                                  { start_date: max_days.days.ago })

    # heuristically evaluate each retrieved column
    heuristic_values = []
    column_ids = []
    column_subset.each do |column|
      heuristic_values << heuristic_column_value(column)
      column_ids << column.id
    end
    
    # select only the top rated 'num' of columns 
    selected_column_ids = []
    num.times do |_|
      break if heuristic_values.empty?
      heuristic_index = heuristic_values.index heuristic_values.max
      selected_column_ids << column_ids[heuristic_index]
      heuristic_values.delete_at heuristic_index
      column_ids.delete_at heuristic_index
    end
    !selected_column_ids.empty? ? column_subset.find(selected_column_ids) : Article.none
  end
end

