class ConvertController < ApplicationController

  def upload
    a = ArchiveFile.create! input: upload_params[:file]
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
    params.require(:archive).permit(:file)
  end
end
