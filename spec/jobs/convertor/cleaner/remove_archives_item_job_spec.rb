# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Convertor::Cleaner::RemoveArchivesItemJob do
  subject { described_class }

  let(:archive_file) { create :archive_file, :completed }

  specify '.perform' do
    expect{
      subject.perform_now(archive_file_id: archive_file.id)
    }.to change{ archive_file.reload.input? }.to(false)
     .and change{ archive_file.reload.output? }.to(false)
  end
end


