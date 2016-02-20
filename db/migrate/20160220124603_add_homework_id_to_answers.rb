class AddHomeworkIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :homework_id, :text
  end
end
