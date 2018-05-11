class CreateColumns < ActiveRecord::Migration[5.1]
  def change
    create_table :columns do |t|
      t.integer :author_id

      t.timestamps
    end
  end
end
