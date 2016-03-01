class AddAttachmentToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks, :attachment, :string
  end
end
