require 'rails_helper'

RSpec.describe Convertor::ConvertJob do
  subject { described_class }

  describe '.perform' do
    let(:archive_file) { create :archive_file }

    specify 'should completed' do
      expect{
        subject.perform_now(archive_file_id: archive_file.id)
      }.to change{archive_file.reload.state}.from('pending').to('completed')
    end
  end
end
