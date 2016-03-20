class Discussion < ActiveRecord::Base
  validates :title, :description, presence: true
  has_many :messages, dependent: :destroy
end
