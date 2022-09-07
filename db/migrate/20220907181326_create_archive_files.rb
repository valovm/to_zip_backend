class CreateArchiveFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :archive_files, id: :uuid do |t|
      t.string :input
      t.string :output
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
