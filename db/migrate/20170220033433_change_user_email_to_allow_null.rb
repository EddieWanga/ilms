class ChangeUserEmailToAllowNull < ActiveRecord::Migration
  def change
    change_column_null :users, :email, true
  end
end