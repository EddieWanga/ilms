class ChangeAttendanceDescriptionDefaultTo0 < ActiveRecord::Migration
  def change
    change_column :attendances, :description, :integer, :default => 0
  end
end
