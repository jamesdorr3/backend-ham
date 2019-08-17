class AddFdcIdToFoods < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :fdcId, :bigint
    add_column :foods, :calcium, :float
    add_column :foods, :iron, :float
    add_column :foods, :trans_fat, :float
    add_column :foods, :alcohol, :float
    add_column :foods, :caffeine, :float
    add_column :foods, :mono_fat, :float
    add_column :foods, :poly_fat, :float
    add_column :foods, :lactose, :float
    remove_column :foods, :serving_unit_name, :string
    remove_column :foods, :serving_unit_amount, :float
    remove_column :foods, :unit_size, :int
    add_column :foods, :additional_search_words, :string
    add_column :foods, :description, :string
  end
end
