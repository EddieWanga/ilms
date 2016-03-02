class AddDownloadLinkToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks, :download_link, :string
  end
end
