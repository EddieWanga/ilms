class AddDownloadLinkToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :download_link, :string
  end
end
