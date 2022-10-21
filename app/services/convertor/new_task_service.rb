module Convertor
  class NewTaskService < BaseService
    def call(file:)
      yield validate(file: file)
      yield Failure(errors: Array.wrap(Convertor.status)) unless Convertor.ok?
      a = ArchiveFile.create input: file
      Convertor::ConvertJob.perform_later archive_file_id: a.id
      Success(archive_file: a)
    rescue UncaughtThrowError => e
      Failure(errors: Array.wrap(e.message))
    end

    private

    def validate(file:)
      return Failure(errors: Array.wrap(:unknown_format_file)) unless Convertor::ConvertService::EXTRACTION_SERVICE.valid?(file.original_filename)
      return Failure(errors: Array.wrap(:filesize_is_too_large)) if file.size > Convertor.max_input_fize_size

      Success(true)
    end
  end
end

