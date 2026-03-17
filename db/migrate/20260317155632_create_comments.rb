class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :post, null: false, foreign_key: true
      t.references :comment, null: true, foreign_key: true

      t.timestamps
    end
  end
end
