require 'rails_helper'

RSpec.describe 'Converts', type: :request do

  # GET api/v1/convert
  describe '/upload' do
    let(:base_url) { '/api/v1/convert' }

    it 'with valid file' do
      get base_url
      expect(response).to have_http_status(200)
    end
  end

  # POST api/v1/convert/upload
  describe '/upload' do
    let(:base_url) { '/api/v1/convert/upload' }

    let(:valid_params_file) do
      file_url = Rails.root.join('spec', 'files', 'archives', 'extract', 'input', 'Кирилица.rar').to_s
      { file: Rack::Test::UploadedFile.new(file_url) }
    end

    it 'with valid file' do
      post base_url, params: valid_params_file
      expect(response).to have_http_status(201)
    end
  end

  # GET api/v1/convert/status?id=
  describe '/status' do
    let(:base_url) { '/api/v1/convert/status' }
    let(:archive_file) { create :archive_file }

    it 'with valid file' do
      get base_url, params: { id: archive_file.id }
      expect(response).to have_http_status(200)
    end
  end

  # GET api/v1/convert/status?id=
  describe '/status' do
    let(:base_url) { '/api/v1/convert/status' }
    let(:archive_file) { create :archive_file }

    it 'with valid file' do
      get base_url, params: { id: archive_file.id }
      expect(response).to have_http_status(200)
    end
  end

  # GET api/v1/convert/download?id=
  describe '/download' do
    let(:base_url) { '/api/v1/convert/download' }
    let(:archive_file) { create :archive_file, :completed }

    it 'with valid file' do
      get base_url, params: { id: archive_file.id }
      expect(response).to have_http_status(200)
    end
  end
end
