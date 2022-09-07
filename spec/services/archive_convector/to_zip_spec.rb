require 'rails_helper'

RSpec.describe ArchiveConvector::ToZip do
  subject { ArchiveConvector::ToZip.new }

  describe '.call' do
    let(:path_to_folder) { Rails.root.join('spec', 'files', 'archives', 'zip', 'input').to_s }
    let(:path_to_file) { Rails.root.join('tmp', 'archive_convertor', 'zip', 'output', 'Кирилица').to_s }

    after do
      File.delete("#{path_to_file}.zip")
    end

    specify do
      filename = subject.call path_to_folder, path_to_file
      expect(File.exist?(filename)).to be_truthy
    end
  end
end
