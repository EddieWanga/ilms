class AddAttendanceDescriptionToUserAttendance < ActiveRecord::Migration
  def change
    add_column :user_attendances, :attendance_description, :integer
  end
end
