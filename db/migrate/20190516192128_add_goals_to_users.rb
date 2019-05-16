class AddGoalsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :calories, :integer
    add_column :users, :fat, :integer
    add_column :users, :carbs, :integer
    add_column :users, :protein, :integer
  end
end
