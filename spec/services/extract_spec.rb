require 'rails_helper'

def folder_to_hash(folder)
  entries = Dir.entries(folder) - %w[. .. .DS_Store]
  entries.reduce({}) do |res, item|
    res[item] = if File.directory? File.join(folder, item)
                  folder_to_hash File.join(folder, item)
                else
                  :file
                end
    res
  end
end

RSpec.describe ArchiveConvector::Extract do
  subject { ArchiveConvector::Extract }

  let(:path_to_output_folder) { Rails.root.join('tmp', 'archive_convertor', 'extract', 'output').to_s }
  let(:path_to_rar_file) {
    Rails.root.join('spec', 'files_for_test', 'archives', 'extract', 'input', 'Кирилица.rar').to_s
  }
  let(:entries) do
    {
      'Подпапка' => {
        'image.jpg' => :file,
        'lea.pdf' => :file,
        'картинка с пробелом(*)(.).jpg' => :file,
        'Финалочка.xlsx' => :file,
        'Подпапка.tar' => :file,
        'Подпапка.zip' => :file
      },
      'Подпапка.tar' => :file,
      'Подпапка.rar' => :file
    }
  end

  describe 'Call' do
    after do
      FileUtils.rm_rf "#{path_to_output_folder}/Кирилица"
    end

    specify do
      path = subject.call path_to_rar_file, path_to_output_folder
      result = folder_to_hash path
      expect(result).to eq(entries)
    end
  end
end
