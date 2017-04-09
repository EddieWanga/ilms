class RemoveDescriptionFromAttendance < ActiveRecord::Migration
  def change
    remove_column :attendances, :description
  end
end
