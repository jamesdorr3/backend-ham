class CreateChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :choices do |t|
      t.belongs_to :food, foreign_key: true
      t.string :nix_id
      t.string :nix_name
      t.belongs_to :day, foreign_key: true
      t.float :amount
      t.string :measure
      t.belongs_to :category, foreign_key: true
      t.integer :index

      t.timestamps
    end
  end
end
