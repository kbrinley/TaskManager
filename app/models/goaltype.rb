class Goaltype < ActiveRecord::Base
  attr_accessible :label, :listorder, :daysinperiod
  
  has_many :goal
  
  default_scope :order => 'listorder asc'
end
