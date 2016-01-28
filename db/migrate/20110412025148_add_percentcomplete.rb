class AddPercentcomplete < ActiveRecord::Migration
  def self.up
    add_column :tasks, :percentcomplete, :integer
    add_column :goals, :percentcomplete, :integer
  end

  def self.down
    remove_column :tasks, :percentcomplete
    remove_column :goals, :percentcomplete
  end
end
