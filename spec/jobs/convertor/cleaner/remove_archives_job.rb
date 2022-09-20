# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Convertor::Cleaner::RemoveArchivesJob do
  subject { described_class }

  before do
    create :archive_file, :completed, updated_at: 40.minutes.ago
    create :archive_file, :failed, updated_at: 40.minutes.ago
  end


  specify '.perform' do
    expect{
      subject.perform_now
    }.to_not raise_exception
  end
end


