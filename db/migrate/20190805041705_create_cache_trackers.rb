class CreateCacheTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :cache_trackers do |t|
      t.integer :page
      t.boolean :searching

      t.timestamps
    end
  end
end
