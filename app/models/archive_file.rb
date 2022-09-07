class ArchiveFile < ApplicationRecord
  mount_uploader :input, InputArchiveFileUploader
  mount_uploader :output, OutputArchiveFileUploader

  enum state: { pending: 0, extracting: 1, compressing: 2, completed: 3, failed: 4 }
end
