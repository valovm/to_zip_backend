class ArchiveConvertJob < ApplicationJob

  def perform(archive_file_id:)
    archive_file = ArchiveFile.pending.find(archive_file_id)
    basename = File.basename(archive_file.input.current_path, '.*')
    folder = File.dirname(archive_file.input.current_path)

    archive_file.update state: :extracting
    extract_folder = ArchiveConvector::Extract.new.call archive_file.input.current_path, folder
    archive_file.update state: :compressing
    zip_path = ArchiveConvector::ToZip.new.call extract_folder, File.join(folder, basename)

    archive_file.state = :completed
    File.open(zip_path) { |f| archive_file.output = f }
    archive_file.save!

    FileUtils.rm_rf extract_folder
    FileUtils.rm_rf zip_path

    archive_file
  end
end
