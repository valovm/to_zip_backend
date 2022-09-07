require 'rubygems'
require 'zip'

module ArchiveConvector
  class ToZip
    def call(path_to_folder, path_to_file)
      @input_dir = path_to_folder
      zipfile_path = "#{path_to_file}.zip"
      entries = Dir.entries(path_to_folder) - %w[. ..]
      ::Zip::File.open(zipfile_path, ::Zip::File::CREATE) do |zipfile|
        write_entries entries, '', zipfile
      end

      zipfile_path
    end

    private

    def write_entries(entries, path, zipfile)
      entries.each do |e|
        zipfile_path = path == '' ? e : File.join(path, e)
        disk_file_path = File.join(@input_dir, zipfile_path)

        if File.directory? disk_file_path
          recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
        else
          put_into_archive(disk_file_path, zipfile, zipfile_path)
        end
      end
    end

    def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      zipfile.mkdir zipfile_path
      subdir = Dir.entries(disk_file_path) - %w[. ..]
      write_entries subdir, zipfile_path, zipfile
    end

    def put_into_archive(disk_file_path, zipfile, zipfile_path)
      zipfile.add(zipfile_path, disk_file_path)
    end
  end
end
