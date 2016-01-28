class Category < ActiveRecord::Base
  attr_accessible :label, :listorder, :size
  
  belongs_to :user
  has_many :task
  has_many :task_history
  
  default_scope :order => 'listorder asc'
end
