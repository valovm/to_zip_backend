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
    result = Convertor::NewTaskService.call(file: upload_params[:file])
    if result.success?
      archive_file = result.value![:archive_file]
      render json: { archive_file: {
        id: archive_file.id,
        filename: File.basename(archive_file.input_identifier, '.*'),
        ext: File.extname(archive_file.input_identifier)
      } }, status: 201
    else
      render json_api_errors(result.failure[:errors], 422)
    end
  end

  def status
    a = ArchiveFile.find(params[:id])
    render json: { archive_file: { state: a.state } }
  end

  def download
    a = ArchiveFile.seeding.find(params[:id])
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
