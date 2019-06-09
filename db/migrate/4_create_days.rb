class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.string :name
      t.belongs_to :goal, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
