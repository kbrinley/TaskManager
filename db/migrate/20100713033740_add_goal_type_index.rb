class AddGoalTypeIndex < ActiveRecord::Migration
  def self.up
    add_index :goals, :goaltype_id
  end

  def self.down
    drop_index :goals, :goaltype_id
  end
end
