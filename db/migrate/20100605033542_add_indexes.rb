class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :tasks, :user_id
    
    add_index :goals, :user_id
    
    add_index :users, :email, :unique => true
    
    add_index :categories, :user_id
  end

  def self.down
    drop_index :tasks, :user_id
    
    drop_index :goals, :user_id
    
    drop_index :users, :email
    
    drop_index :categories, :user_id
  end
end
