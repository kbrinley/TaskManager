class AddTaskIndex < ActiveRecord::Migration
  def self.up
    add_index :tasks, :user_id
  end

  def self.down
    drop_index :tasks, :user_id
  end
end
