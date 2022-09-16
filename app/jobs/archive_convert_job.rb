class ArchiveConvertJob < ApplicationJob
  def perform(archive_file_id:)
    archive_file = ArchiveFile.find(archive_file_id)
    ConvertService.call archive_file: archive_file
  end
end
