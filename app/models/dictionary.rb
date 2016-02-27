class Dictionary < ActiveRecord::Base
  validates_uniqueness_of :confirm_code
end
