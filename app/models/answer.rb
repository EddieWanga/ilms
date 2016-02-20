class Answer < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validate :attachment_size_validation, :if => "attachment?"
  def attachment_size_validation
    if attachment.size > 50.megabytes
	  errors.add(:base, "Attachment should be less than 10MB")
	end
  end 
end
