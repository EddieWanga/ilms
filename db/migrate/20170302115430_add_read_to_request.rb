class AddReadToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :read, :integer
  end
end
