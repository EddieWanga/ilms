class Attendance < ActiveRecord::Base
  has_many :user_attendances
  has_many :users, :through => :user_attendances

end
