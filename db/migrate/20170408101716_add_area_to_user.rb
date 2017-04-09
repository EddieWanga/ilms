class AddAreaToUser < ActiveRecord::Migration
  def change
    add_column :users, :area, :integer
  end
end
