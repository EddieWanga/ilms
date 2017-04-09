class CreateUserAttendances < ActiveRecord::Migration
  def change
    create_table :user_attendances do |t|
      t.integer :user_id
      t.string :attendance_date
      t.integer :attendance_id

      t.timestamps null: false
    end
  end
end
