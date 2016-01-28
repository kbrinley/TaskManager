class CreateGoalTypes < ActiveRecord::Migration
  def self.up
    create_table :goal_types do |t|
      t.string :label
      t.integer :daysinperiod
      t.integer :listorder

      t.timestamps
    end
  end

  def self.down
    drop_table :goal_types
  end
end
