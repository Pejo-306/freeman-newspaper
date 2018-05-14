class AddThumbnailToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :thumbnail, :string
  end
end

