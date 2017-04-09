class RenameAttendancesLangToDistrict < ActiveRecord::Migration
  def change
    rename_column :attendances, :lang, :district
  end
end
