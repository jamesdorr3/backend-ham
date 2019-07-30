class AddFdcIdToFoods < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :fdcId, :bigint
  end
end
