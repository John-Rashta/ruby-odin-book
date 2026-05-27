class ChangePostContentToPolymorphic < ActiveRecord::Migration[8.1]
  def change
    change_table :posts do |t|
      t.belongs_to :postable, polymorphic: true
      t.remove :content
    end
  end
end
