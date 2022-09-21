module Convertor

  QUEUE_LIMIT = ENV['CONVERTOR_LIMIT_QUEUE'].to_i
  MAX_INPUT_FILE_SIZE = ENV['CONVERTOR_LIMIT_INPUT_FILE_SIZE'].to_i
  SEED_TIMEOUT = ENV['CONVERTOR_SEED_TIMEOUT'].to_i
  SEED_LIMIT = ENV['CONVERTOR_SEED_LIMIT'].to_i

  def self.ok?
    Convertor.status == :ok
  end

  def self.status
    return :queue_is_full if ArchiveFile.pending.count >= QUEUE_LIMIT
    return :seed_is_full if ArchiveFile.seeding.count >= SEED_LIMIT

    :ok
  end

  def self.max_input_fize_size
    MAX_INPUT_FILE_SIZE
  end

  def self.seed_timeout
    SEED_TIMEOUT
  end
end
