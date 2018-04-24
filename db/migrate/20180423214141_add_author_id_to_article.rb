class AddAuthorIdToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :author_id, :integer
  end
end
