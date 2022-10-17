# frozen_string_literal: true

module ArchiveConvector
  class Extract
    def valid?(path_to_file)
      Extract.extension_allowlist.include? get_extname(path_to_file)
    end

    def self.extension_allowlist
      # plan: .arj .lha .tar.bz tar.7z
      %w[rar tar 7z jar tbz2 tgz]
    end

    def call(path_to_file, path_to_folder)
      raise 'unknown_format_file' unless valid?(path_to_file)

      result_folder = File.join path_to_folder, File.basename(path_to_file, '.*')
      path_to_folder = File.join path_to_folder, SecureRandom.alphanumeric
      Dir.mkdir path_to_folder
      path_to_folder = extract path_to_file, path_to_folder
      File.rename path_to_folder, result_folder

      result_folder
    end

    private

    def get_extname(path_to_file)
      double_extname = File.basename(path_to_file).split('.').last(2).join('.')
      return double_extname if %w[tar.bz].include?(double_extname)

      File.extname(path_to_file)[1..-1]
    end

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
