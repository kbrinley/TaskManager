class PluralizeItemColor < ActiveRecord::Migration
  def self.up
    rename_table :itemcolor, :itemcolors
  end

  def self.down
    rename_table :itemcolors, :itemcolor
  end
end
