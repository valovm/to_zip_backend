module Convertor
  class ConvertService
    EXTRACTION_SERVICE ||= ::ArchiveConvector::Extract.new
    TO_ZIP_SERVICE ||= ::ArchiveConvector::ToZip.new

    def self.call(archive_file:)
      archive_file.update! state: :extracting
      basename = File.basename(archive_file.input.current_path, '.*')
      folder = File.dirname(archive_file.input.current_path)
      extract_folder = EXTRACTION_SERVICE.call archive_file.input.current_path, folder
      archive_file.update! state: :compressing
      zip_path = TO_ZIP_SERVICE.call extract_folder, File.join(folder, basename)

      archive_file.state = :seeding
      archive_file.seed_started_at = DateTime.current
      File.open(zip_path) { |f| archive_file.output = f }
      archive_file.save!

      FileUtils.rm_rf extract_folder
      FileUtils.rm_rf zip_path

      archive_file
    rescue
      archive_file.state = :failed
      archive_file.remove_input!
      archive_file.save!
    end
  end
end

