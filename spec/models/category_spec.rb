require 'spec_helper'

describe Category do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :label => "value for label",
      :size => 1,
      :listorder => 1,
      :location => "value for location"
    }
  end

  it "should create a new instance given valid attributes" do
    Category.create!(@valid_attributes)
  end
end
