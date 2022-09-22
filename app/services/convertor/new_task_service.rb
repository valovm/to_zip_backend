module Convertor
  class NewTaskService < BaseService
    def call(file:)
      yield validate(file:)
      a = ArchiveFile.create! input: file
      Convertor::ConvertJob.perform_later archive_file_id: a.id

      Success(archive_file: a)
    end

    private

    def validate(file:)
      unless Convertor::ConvertService::EXTRACTION_SERVICE.class.extension_allowlist.include?(File.extname(file.original_filename))
        return Failure(errors: Array.wrap(:unknown_format_file))
      end
      return Failure(errors: Array.wrap(:filesize_is_too_large)) if file.size > Convertor.max_input_fize_size
      return Failure(errors: Array.wrap(Convertor.status)) unless Convertor.ok?

      Success(true)
    end
  end
end

