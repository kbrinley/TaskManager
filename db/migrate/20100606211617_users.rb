class Users < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    remove_column :users, :firstname
    remove_column :users, :middlename
    remove_column :users, :lastname
  end

  def self.down
    remove_column :users, :name
    add_column :users, :firstname, :string
    add_column :users, :middlename, :string
    add_column :users, :middlename, :string
  end
end
