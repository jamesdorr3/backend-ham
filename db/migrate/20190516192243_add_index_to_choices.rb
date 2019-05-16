class AddIndexToChoices < ActiveRecord::Migration[5.2]
  def change
    add_column :choices, :index, :integer
  end
end
