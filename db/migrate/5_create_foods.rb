class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.string :name
      t.integer :serving_grams
      t.string :serving_unit_name
      t.float :serving_unit_amount
      t.string :brand
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
      t.string :upc
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
