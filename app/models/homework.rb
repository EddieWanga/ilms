class Homework < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :title, :description, :district, presence: true 
  validate :attachment_size_validation, :if => "attachment?"

  has_many :answers

  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :homework_users
  has_many :members, through: :homework_users, source: :user
  
  def attachment_size_validation
    if attachment.size > 50.megabytes
	  errors.add(:base, "Attachment should be less than 50MB")
    end
  end 
end
