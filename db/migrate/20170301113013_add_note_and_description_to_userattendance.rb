class AddNoteAndDescriptionToUserattendance < ActiveRecord::Migration
  def change
    add_column :user_attendances, :note, :string
    add_column :user_attendances, :description, :integer
  end
end
