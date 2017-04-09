class UserAttendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :attendance
end
