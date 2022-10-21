require 'rails_helper'

RSpec.describe Convertor::NewTaskService do
  subject { described_class }


  describe '.call' do
    let(:file) do
      file_url = Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.rar').to_s
      Rack::Test::UploadedFile.new(file_url)
    end
    context 'valid' do
      specify do
        expect {
          result = subject.call file: file
          expect(result.success?).to be_truthy
        }.to change{ArchiveFile.pending.count}.from(0).to(1)
      end
    end

    context 'race condition' do
      before do
        stub_const('Convertor::QUEUE_LIMIT', 2)
      end
      specify do
        concurrency_level = ActiveRecord::Base.connection.pool.size - 1
        expect(concurrency_level).to be > 2
        result = []
        threads = Array.new(concurrency_level) do |_i| ad.new do
            result << subject.call(file: file)
          end
        end
        threads.each(&:join)
        expect(ArchiveFile.count).to eq(2)
        expect(result.count(&:success?)).to eq(2)
        expect(result.count).to eq(concurrency_level)
      end
    end

    context 'seed is full' do
      before do
        stub_const('Convertor::SEED_LIMIT', 0)
      end
      specify do
        expect {
          result = subject.call file: file
          expect(result.failure?).to be_truthy
          expect(result.failure[:errors].first).to eq(:seed_is_full)
        }.to_not change{ ArchiveFile.pending.count }.from(0)
      end
    end

  end
end
