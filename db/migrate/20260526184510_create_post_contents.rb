class CreatePostContents < ActiveRecord::Migration[8.1]
  def change
    create_table :post_contents do |t|
      t.timestamps
    end
  end
end
