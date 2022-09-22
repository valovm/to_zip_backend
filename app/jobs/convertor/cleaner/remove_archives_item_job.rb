module Convertor
  module Cleaner
    # RemoveArchivesItemJob
    class RemoveArchivesItemJob < ApplicationJob
      def perform(archive_file_id:)
        archive_file = ArchiveFile.find(archive_file_id)
        archive_file.state = :completed
        archive_file.remove_input!
        archive_file.remove_output!
        archive_file.save!
      end
    end
  end
end

