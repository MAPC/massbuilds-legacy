class WalkScore

  attr_reader :content

  BASE_URL = 'http://api.walkscore.com/score?format=json'.freeze

  def initialize(resource, cached: true)
    @resource = resource
    @cached = cached
    @lat, @lon = resource.latitude.to_f, resource.longitude.to_f
    @content = {}
  end

  def get
    @content ||= JSON.parse(response).with_indifferent_access
  end

  def empty?
    @content.keys.count <= 1 # Status key is always present
  end

  private

  def response
    Net::HTTP.get_response(URI(url)).body
  end

  def url
    "#{BASE_URL}&lat=#{@lat}&lon=#{@lon}&wsapikey=#{ENV['WALKSCORE_API_KEY']}"
  end

end
