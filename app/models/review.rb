class Review < ActiveRecord::Base
  validates :point, presence: true
  belongs_to :answer
end
