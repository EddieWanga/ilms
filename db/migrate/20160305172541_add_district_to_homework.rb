class AddDistrictToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks, :district, :string
  end
end
