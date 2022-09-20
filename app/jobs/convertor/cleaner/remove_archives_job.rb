# frozen_string_literal: true

module Convertor
  module Cleaner
    class RemoveArchivesJob < ApplicationJob
      def perform
        ArchiveFile.where(state: %i[failed complited])
                   .where('updated_at < :current_time', current_time: DateTime.current - 30.minutes)
                   .find_each do |item|
          RemoveArchivesItemJob.perform_later(archive_file_id: item.id)
        end
      end
    end
  end
end

