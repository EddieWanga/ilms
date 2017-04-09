class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.string :class
      t.string :date
      t.integer :description
      t.timestamps null: false
    end
  end
end
