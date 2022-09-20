class AddSeedStartedAtToArchiveFile < ActiveRecord::Migration[7.0]
  def change
    add_column :archive_files, :seed_started_at, :datetime, null: true
  end
end
