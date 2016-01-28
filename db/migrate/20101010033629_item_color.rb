class ItemColor < ActiveRecord::Migration
  def self.up
    create_table :itemcolor do |t|
      t.integer :user_id
      t.integer :listorder
      t.string :color
      t.string :label
      
      t.timestamps
    end
    
  end

  def self.down
    drop_table :itemcolor
  end
end
