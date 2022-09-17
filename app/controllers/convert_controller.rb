class ConvertController < ApplicationController

  def index
    render json: {
      extract_extname: ArchiveConvector::Extract.extension_allowlist,
      limit_file_size: '100 MB'
    }
  end

  def upload
    a = ArchiveFile.create! input: upload_params[:file]
    ArchiveConvertJob.perform_later archive_file_id: a.id
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
