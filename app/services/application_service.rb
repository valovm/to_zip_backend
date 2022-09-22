class ApplicationService
  def self.check_status
    ActiveRecord::Base.connection
    return :bad unless ActiveRecord::Base.connected?
    return Convertor.status unless Convertor.ok?

    :ok
  end
end
