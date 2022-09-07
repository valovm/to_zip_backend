require 'rails_helper'

RSpec.describe ArchiveConvector do
  subject { ArchiveConvector }

  describe '.convert' do
    let(:path_to_output_folder) { Rails.root.join('tmp', 'archive_convertor', 'zip', 'output').to_s }
    let(:path_to_rar_file) do
      Rails.root.join('spec', 'files_for_test', 'archives', 'extract', 'input', 'Кирилица.rar').to_s
    end

    specify do
      filename = subject.convert path_to_rar_file, path_to_output_folder
      expect(File.exist?(filename)).to be_truthy

      File.delete(filename)
    end
  end
end
