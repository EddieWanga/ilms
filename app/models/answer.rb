class Answer < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :title, presence: true
  validate :attachment_size_validation, :if => "attachment?"
  
  belongs_to :homework
  belongs_to :author, class_name: "User", foreign_key: :user_id  
  
  def attachment_size_validation
    if attachment.size > 50.megabytes
	  errors.add(:base, "Attachment should be less than 10MB")
    end
  end 

  def editable_by?(user)
    return (user && author == user) 
  end
end
