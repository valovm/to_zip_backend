# frozen_string_literal: true

module Convertor
  module Cleaner
    class RemoveArchivesJob < ApplicationJob
      def perform
        time = DateTime.current - Convertor.seed_timeout.seconds
        ArchiveFile.seeding.where('seed_started_at < :time', time:).find_each do |item|
          RemoveArchivesItemJob.perform_later(archive_file_id: item.id)
        end
      end
    end
  end
end

