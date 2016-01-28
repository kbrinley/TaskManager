class AddItemColorColumn < ActiveRecord::Migration
  def self.up
    add_column :tasks, :itemcolor_id, :integer
  end

  def self.down
    remove_column :tasks, :itemcolor_id
  end
end
