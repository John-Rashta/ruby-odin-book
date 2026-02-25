class ChangeTypeColumnName < ActiveRecord::Migration[8.1]
  def change
    change_table :requests do |t|
      t.rename :type, :table_type
    end
  end
end
