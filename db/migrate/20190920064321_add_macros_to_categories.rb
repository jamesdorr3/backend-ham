class AddMacrosToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :calories, :float
    add_column :categories, :fat, :float
    add_column :categories, :carbs, :float
    add_column :categories, :protein, :float
  end
end
