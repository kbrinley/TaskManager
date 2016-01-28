class Itemcolor < ActiveRecord::Base
  attr_accessible :listorder, :color, :label
  
  belongs_to :user
  has_many :task
  
  default_scope :order => 'listorder asc'
  
  
end