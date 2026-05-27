class CreatePostImages < ActiveRecord::Migration[8.1]
  def change
    create_table :post_images do |t|
      t.timestamps
    end
  end
end
