class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.integer :user_id
      t.integer :goaltype_id
      t.string :description
      t.datetime :datecompleted

      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
