require 'rails_helper'

RSpec.describe 'Converts', type: :request do

  # GET api/v1/convert
  describe '/convert' do
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

    context 'when valid response' do
      specify do
        post base_url, params: valid_params_file
        expect(response).to have_http_status(201)
      end
    end

    context 'when large file' do
      before do
        allow(Convertor).to receive(:max_input_fize_size).and_return(1.megabytes)
      end
      specify do
        post base_url, params: valid_params_file
        expect(response).to have_http_status(422)
      end
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
    let(:archive_file) { create :archive_file, :seeding }

    it 'with valid file' do
      get base_url, params: { id: archive_file.id }
      expect(response).to have_http_status(200)
    end
  end
end
