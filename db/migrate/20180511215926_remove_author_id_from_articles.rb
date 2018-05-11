class RemoveAuthorIdFromArticles < ActiveRecord::Migration[5.1]
  def change
    remove_column :articles, :author_id, :integer
  end
end
