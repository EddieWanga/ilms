class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :confirm_code
      t.string :password

      t.timestamps null: false
    end
  end
end
