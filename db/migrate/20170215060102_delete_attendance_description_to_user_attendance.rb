class DeleteAttendanceDescriptionToUserAttendance < ActiveRecord::Migration
  def change
    remove_column :user_attendances, :attendance_description
  end
end
