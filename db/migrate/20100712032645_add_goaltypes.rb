class AddGoaltypes < ActiveRecord::Migration
  def self.up
    create_table :goaltypes do |t|
      t.string :label
      t.integer :daysinperiod
      t.integer :listorder

      t.timestamps
    end
    
    Goaltype.create(:label => "Daily", :daysinperiod => 1, :listorder => 1)
    Goaltype.create(:label => "Weekly", :daysinperiod => 7, :listorder => 2)
    Goaltype.create(:label => "Monthly", :daysinperiod => 30, :listorder => 3)
  end

  def self.down
    drop_table :goaltypes
  end
end
