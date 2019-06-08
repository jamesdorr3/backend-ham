class CreateMeasures < ActiveRecord::Migration[5.2]
  def change
    create_table :measures do |t|
      t.belongs_to :food, foreign_key: true
      t.float :amount
      t.float :grams
      t.string :name

      t.timestamps
    end
  end
end
