class ChangeUserEmailToDefaultNull < ActiveRecord::Migration
  def change
    change_column_default :users, :email, nil
  end
end
