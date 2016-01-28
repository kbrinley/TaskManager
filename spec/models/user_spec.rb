require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :email => "valuefor@email.com",
      :password => "value for password",
      :salt => "value for salt",
      :name => "my name",
      :premiumaccount => false,
      :adminaccount => false
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
