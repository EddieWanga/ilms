class AddClassToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :class, :string
  end
end
