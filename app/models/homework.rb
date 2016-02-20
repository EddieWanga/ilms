class Homework < ActiveRecord::Base
  validates :title, :description, presence: true 
end
