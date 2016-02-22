class Homework < ActiveRecord::Base
  validates :title, :description, presence: true 
  has_many :answers

  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :homework_users
  has_many :members, through: :homework_users, source: :user
end
