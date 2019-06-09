class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.belongs_to :user, foreign_key: true
      t.float :calories
      t.float :fat
      t.float :carbs
      t.float :protein
      t.string :name
      t.boolean :deleted

      t.timestamps
    end
  end
end
