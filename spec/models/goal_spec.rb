require 'spec_helper'

describe Goal do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :goaltype_id => 1,
      :description => "value for description",
      :datecompleted => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Goal.create!(@valid_attributes)
  end
end
