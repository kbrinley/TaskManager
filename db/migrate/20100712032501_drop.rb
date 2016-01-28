class Drop < ActiveRecord::Migration
  def self.up
    drop_table :goal_types
  end

  def self.down
        create_table :goal_types do |t|
      t.string :label
      t.integer :daysinperiod
      t.integer :listorder

      t.timestamps
    end
  end
end
