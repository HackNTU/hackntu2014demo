class Project < ActiveRecord::Base
  belongs_to :user
  acts_as_votable 
  validates_presence_of :title, :on => :create, :message => "不能為空"
  validates_presence_of :description, :on => :create, :message => "不能為空"
end
