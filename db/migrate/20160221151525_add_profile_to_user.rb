class AddProfileToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :district, :string
    add_column :users, :role, :integer
  end
end
