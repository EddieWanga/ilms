class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :confirm_code

      t.timestamps null: false
    end
  end
end
