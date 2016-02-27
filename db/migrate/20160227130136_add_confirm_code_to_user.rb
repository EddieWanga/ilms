class AddConfirmCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirm_code, :string
  end
end
