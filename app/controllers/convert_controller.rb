class ConvertController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    render json: {
      state: ApplicationService.check_status,
      extract_extname: ArchiveConvector::Extract.extension_allowlist,
      limit_file_size: number_to_human_size(Convertor.max_input_fize_size, precision: 0)
    }
  end

  def upload
    raise 'filesize_is_too_large' if upload_params[:file].size > Convertor.max_input_fize_size
    raise Convertor.status unless Convertor.ok?

    a = ArchiveFile.create! input: upload_params[:file]
    Convertor::ConvertJob.perform_later archive_file_id: a.id
    render json: { archive_file: {
      id: a.id,
      filename: File.basename(a.input_identifier, '.*'),
      ext: File.extname(a.input_identifier)
    } }, status: :created
  end

  def status
    a = ArchiveFile.find(params[:id])
    render json: { archive_file: { state: a.state } }
  end

  def download
    a = ArchiveFile.completed.find(params[:id])
    send_file(
      a.output.current_path,
      disposition: 'attachment',
      type: 'application/zip',
      filename: File.basename(a.output_identifier)
    )
  end

  private

  def upload_params
    params.permit(:file)
  end
end
