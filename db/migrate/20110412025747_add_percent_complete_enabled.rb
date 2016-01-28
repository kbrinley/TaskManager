class AddPercentCompleteEnabled < ActiveRecord::Migration
  def self.up
    add_column :users, :percentcompleteenabled, :boolean
  end

  def self.down
    remove_column :users, :percentcompleteenabled
  end
end
