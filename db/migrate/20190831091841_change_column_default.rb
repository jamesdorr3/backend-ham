class ChangeColumnDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :foods, :choice_count, from: nil, to: 0
    change_column_null :foods, :choice_count, false
  end
end
