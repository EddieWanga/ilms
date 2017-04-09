class DropScoreAdnScoreUsersAndScoreHomeworks < ActiveRecord::Migration
  def change
    drop_table :scores do |t|
      t.integer :score
      t.timestamps null: false
    end
    
    drop_table :score_users do |t|
      t.integer :score_id
      t.integer :user_id
      t.timestamps null: false
    end

    drop_table :score_homeworks do |t|
      t.integer :score_id
      t.integer :homework_id
      t.timestamps null: false
    end
  end
end
