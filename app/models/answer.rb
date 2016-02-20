class Answer < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :title, presence: true
  validate :attachment_size_validation, :if => "attachment?"
  
  belongs_to :homework
  
  def attachment_size_validation
    if attachment.size > 50.megabytes
	  errors.add(:base, "Attachment should be less than 10MB")
	end
  end 
end
