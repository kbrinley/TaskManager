class Addgoalcompletedflag < ActiveRecord::Migration
  def self.up
    add_column :goals, :completedflag, :boolean
  end

  def self.down
    remove_column :goals, :completedflag
  end
end
