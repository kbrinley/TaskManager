class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :user_id
      t.string :label
      t.integer :size
      t.integer :listorder
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
