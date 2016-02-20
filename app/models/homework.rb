class Homework < ActiveRecord::Base
  validates :title, :description, presence: true 
  has_many :answers
end
