class AddTaskHistory < ActiveRecord::Migration
  def self.up
    create_table :taskhistories do |t|
      t.integer :task_id
      t.integer :category_id
      
      t.timestamps
    end
    
    add_index :taskhistories, :task_id
    
    add_index :taskhistories, :category_id
  end

  def self.down
    drop table :taskhistory
  end
end
