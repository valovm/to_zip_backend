module Convertor

  QUEUE_LIMIT = ENV['CONVERTOR_LIMIT_QUEUE'].to_i
  MAX_INPUT_FILE_SIZE = ENV['CONVERTOR_LIMIT_INPUT_FILE_SIZE'].to_i

  def self.ok?
    Convertor.status == :ok
  end

  def self.status
    return :queue_is_full if ArchiveFile.pending.count > QUEUE_LIMIT

    :ok
  end

  def self.max_input_fize_size
    MAX_INPUT_FILE_SIZE
  end
end
