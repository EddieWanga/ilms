class Answer < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader 
end
