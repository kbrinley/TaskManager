class AddUserExpiration < ActiveRecord::Migration
  def self.up
    add_column :users, :accountexpiration, :datetime
  end

  def self.down
    remove_column :users, :accountexpiration
  end
end
