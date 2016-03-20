class Message < ActiveRecord::Base
  validates :description, presence: true
  belongs_to :author, class_name: "User", foreign_key: :user_id  
  belongs_to :discussion
end
