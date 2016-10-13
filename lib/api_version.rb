module APIVersion

  attr_reader :version, :default

  def self.version(version, default: false)
    @version = version.to_i
    @default = default
    return params
  end

  class << self
    alias_method :v, :version
  end

  def self.params
    {
      module:    module_name,
      header:    header,
      parameter: parameter,
      default:   @default
    }
  end

  private

  def self.module_name
    "V#{@version}"
  end

  def self.header
    {
      name:  "Accept",
      value: "application/vnd.api+json; application/org.massbuilds.v#{@version}"
    }
  end

  def self.parameter
    { name: "version", value: @version.to_s }
  end

end
