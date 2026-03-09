class CreateLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :likes do |t|
      t.timestamps
      t.belongs_to :contentable, polymorphic: true
    end
  end
end
