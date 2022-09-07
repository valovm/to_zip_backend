module ArchiveConvector

  EXTRACTOR_SERVICE ||= Extract.new
  TO_ZIPPER_SERVICE ||= ToZip.new

  def self.convert(input_file_path, output_path)
    filename = File.basename input_file_path, '.*'
    folder = EXTRACTOR_SERVICE.call input_file_path, output_path
    zippath = TO_ZIPPER_SERVICE.call folder, File.join(output_path, filename)
    FileUtils.rm_rf folder

    zippath
  end
end
