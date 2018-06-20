class AddHeuristicValueToColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :columns, :heuristic_value, :decimal
  end
end
