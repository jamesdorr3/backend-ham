class AddDayIdToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :day_id, :bigint
  end
end
