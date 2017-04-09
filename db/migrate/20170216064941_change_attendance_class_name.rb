class ChangeAttendanceClassName < ActiveRecord::Migration
  def change
    rename_column :attendances, :class, :lang
  end
end
