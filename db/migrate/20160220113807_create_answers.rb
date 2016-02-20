class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :title
      t.text :description
      t.text :comment
      t.integer :points
      t.string :attachment

      t.timestamps null: false
    end
  end
end
