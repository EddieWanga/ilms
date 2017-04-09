class AddAttendanceIdToUserAttendance < ActiveRecord::Migration
  def change
    add_column :user_attendances, :attendance_id, :integer
  end
end
