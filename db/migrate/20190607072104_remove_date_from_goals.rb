class RemoveDateFromGoals < ActiveRecord::Migration[5.2]
  def change
    remove_column :goals, :date, :date
  end
end
