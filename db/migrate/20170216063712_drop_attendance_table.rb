class DropAttendanceTable < ActiveRecord::Migration
  def change
    drop_table :attendances
  end
end
