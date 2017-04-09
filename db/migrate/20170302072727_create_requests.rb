class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :date
      t.string :reason
      t.timestamps null: false
    end
  end
end
