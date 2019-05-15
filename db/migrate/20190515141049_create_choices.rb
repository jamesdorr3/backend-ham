class CreateChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :choices do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :food, foreign_key: true
      t.float :amount
      t.string :measure

      t.timestamps
    end
  end
end
