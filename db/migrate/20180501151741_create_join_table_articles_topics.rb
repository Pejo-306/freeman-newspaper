class CreateJoinTableArticlesTopics < ActiveRecord::Migration[5.1]
  def change
    create_join_table :articles, :topics do |t|
      t.index [:article_id, :topic_id]
      t.index [:topic_id, :article_id]
    end
  end
end
