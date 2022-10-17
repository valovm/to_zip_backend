require 'rails_helper'

def folder_to_hash(folder)
  entries = Dir.entries(folder) - %w[. .. .DS_Store]
  entries.each_with_object({}) do |item, res|
    res[item] = if File.directory? File.join(folder, item)
                  folder_to_hash File.join(folder, item)
                else
                  :file
                end
  end
end

RSpec.describe ArchiveConvector::Extract do
  subject { ArchiveConvector::Extract.new }

  shared_examples 'extract_success' do
    specify do
      path = subject.call path_to_rar_file, path_to_output_folder
      result = folder_to_hash path
      expect(entries <= result).to be_truthy
    end
  end

  describe '.call' do
    let(:path_to_output_folder) { Rails.root.join('tmp', 'archive_convertor', 'extract', 'output').to_s }

    after do
      FileUtils.rm_rf "#{path_to_output_folder}/Кирилица"
    end

    context 'Rar file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.rar').to_s
      end
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

      it_behaves_like 'extract_success'
    end

    context 'Tar file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.tar').to_s
      end
      let(:entries) do
        {
          '__MACOSX' => {'Подпапка' => {} },
          'Подпапка' => {
            'image.jpg' => :file,
            'lea.pdf' => :file,
            'картинка с пробелом(*)(.).jpg' => :file,
            'Финалочка.xlsx' => :file
          }
        }
      end

      it_behaves_like 'extract_success'
    end

    context '7z file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.7z').to_s
      end
      let(:entries) do
        {
          'Подпапка' => {
            'image.jpg' => :file,
            'lea.pdf' => :file,
            'картинка с пробелом(*)(.).jpg' => :file,
            'Финалочка.xlsx' => :file
          },
          'image.jpg' => :file,
          'lea.pdf' => :file,
          'картинка с пробелом(*)(.).jpg' => :file,
          'Финалочка.xlsx' => :file
        }
      end

      it_behaves_like 'extract_success'
    end

    context 'JAR file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.jar').to_s
      end
      let(:entries) do
        { 'Кирилица' =>
            {
              'Подпапка' => {
                'image.jpg' => :file,
                'lea.pdf' => :file,
                'картинка с пробелом(*)(.).jpg' => :file,
                'Финалочка.xlsx' => :file
              },
              'image.jpg' => :file,
              'lea.pdf' => :file,
              'картинка с пробелом(*)(.).jpg' => :file,
              'Финалочка.xlsx' => :file
            }
        }

      end

      it_behaves_like 'extract_success'
    end

    context 'TBZ2 file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.tbz2').to_s
      end
      let(:entries) do
        { 'Кирилица' =>
            {
              'Подпапка' => {
                'image.jpg' => :file,
                'lea.pdf' => :file,
                'картинка с пробелом(*)(.).jpg' => :file,
                'Финалочка.xlsx' => :file
              },
              'image.jpg' => :file,
              'lea.pdf' => :file,
              'картинка с пробелом(*)(.).jpg' => :file,
              'Финалочка.xlsx' => :file
            }
        }

      end

      it_behaves_like 'extract_success'
    end

    context 'TGZ file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.tgz').to_s
      end
      let(:entries) do
        { 'Кирилица' =>
            {
              'Подпапка' => {
                'image.jpg' => :file,
                'lea.pdf' => :file,
                'картинка с пробелом(*)(.).jpg' => :file,
                'Финалочка.xlsx' => :file
              },
              'image.jpg' => :file,
              'lea.pdf' => :file,
              'картинка с пробелом(*)(.).jpg' => :file,
              'Финалочка.xlsx' => :file
            }
        }

      end

      it_behaves_like 'extract_success'
    end

    xcontext 'ARJ file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.arj').to_s
      end
      let(:entries) do
        { 'Кирилица' =>
            {
              'Подпапка' => {
                'image.jpg' => :file,
                'lea.pdf' => :file,
                'картинка с пробелом(*)(.).jpg' => :file,
                'Финалочка.xlsx' => :file
              },
              'image.jpg' => :file,
              'lea.pdf' => :file,
              'картинка с пробелом(*)(.).jpg' => :file,
              'Финалочка.xlsx' => :file
            }
        }

      end

      it_behaves_like 'extract_success'
    end

    xcontext 'LHA file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.lha').to_s
      end
      let(:entries) do
        { 'Кирилица' =>
            {
              'Подпапка' => {
                'image.jpg' => :file,
                'lea.pdf' => :file,
                'картинка с пробелом(*)(.).jpg' => :file,
                'Финалочка.xlsx' => :file
              },
              'image.jpg' => :file,
              'lea.pdf' => :file,
              'картинка с пробелом(*)(.).jpg' => :file,
              'Финалочка.xlsx' => :file
            }
        }

      end

      it_behaves_like 'extract_success'
    end

    xcontext 'TAR.BZ file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.tar.bz').to_s
      end
      let(:entries) do
        { 'Кирилица' =>
            {
              'Подпапка' => {
                'image.jpg' => :file,
                'lea.pdf' => :file,
                'картинка с пробелом(*)(.).jpg' => :file,
                'Финалочка.xlsx' => :file
              },
              'image.jpg' => :file,
              'lea.pdf' => :file,
              'картинка с пробелом(*)(.).jpg' => :file,
              'Финалочка.xlsx' => :file
            }
        }

      end

      it_behaves_like 'extract_success'
    end

    xcontext 'TAR.7z file' do
      let(:path_to_rar_file) do
        Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.tar.7z').to_s
      end
      let(:entries) do
        { 'Кирилица' =>
            {
              'Подпапка' => {
                'image.jpg' => :file,
                'lea.pdf' => :file,
                'картинка с пробелом(*)(.).jpg' => :file,
                'Финалочка.xlsx' => :file
              },
              'image.jpg' => :file,
              'lea.pdf' => :file,
              'картинка с пробелом(*)(.).jpg' => :file,
              'Финалочка.xlsx' => :file
            }
        }

      end

      it_behaves_like 'extract_success'
    end
  end
end
