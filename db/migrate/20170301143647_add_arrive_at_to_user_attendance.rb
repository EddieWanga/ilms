class AddArriveAtToUserAttendance < ActiveRecord::Migration
  def change
    add_column :user_attendances, :arrive_at, :datetime
  end
end
