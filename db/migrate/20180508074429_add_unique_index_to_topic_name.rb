class AddUniqueIndexToTopicName < ActiveRecord::Migration[5.1]
  def change
    add_index :topics, :name, unique: true
  end
end
