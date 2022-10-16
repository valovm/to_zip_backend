# frozen_string_literal: true

module ArchiveConvector
  class Extract

    def self.extension_allowlist
      %w[.rar .tar .7z]
    end

    def call(path_to_file, path_to_folder)
      raise 'unknown_format_file' unless Extract.extension_allowlist.include? File.extname(path_to_file)

      result_folder = File.join path_to_folder, File.basename(path_to_file, '.*')
      path_to_folder = File.join path_to_folder, SecureRandom.alphanumeric
      Dir.mkdir path_to_folder
      path_to_folder = extract path_to_file, path_to_folder
      File.rename path_to_folder, result_folder

      result_folder
    end

    private

    def extract(path_to_file, path_to_folder)
      flags = Archive::EXTRACT_PERM
      reader = Archive::Reader.open_filename(path_to_file)
      reader.each_entry do |entry|
        reader.extract entry, flags.to_i, destination: path_to_folder
      end
      reader.close

      path_to_folder
    end
  end
end
