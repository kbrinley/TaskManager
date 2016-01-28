class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :salt
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.boolean :premiumaccount
      t.boolean :adminaccount

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
