class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :answer_id
      t.integer :point
      t.text :comment

      t.timestamps null: false
    end
  end
end
