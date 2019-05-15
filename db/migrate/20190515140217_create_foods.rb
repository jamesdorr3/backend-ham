class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.string :name
      t.integer :serving_grams
      t.float :serving_tsp
      t.float :calories
      t.float :fat
      t.float :carbs
      t.float :protein
      t.float :cholesterol
      t.float :dietary_fiber
      t.float :potassium
      t.float :saturated_fat
      t.float :sodium
      t.float :sugars
      t.string :unit_size
      t.string :brand
      t.bigint :upc

      t.timestamps
    end
  end
end
