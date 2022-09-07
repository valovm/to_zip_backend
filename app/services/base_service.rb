class BaseService
  def self.call(...)
    new.call(...)
  end

  def initialize
    p self.class
    super
  end
end
