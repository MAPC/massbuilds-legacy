class WalkScore

  BASE_URL = 'http://api.walkscore.com/score?format=json'.freeze
  API_KEY = ENV['WALKSCORE_API_KEY']

  def initialize(lat: , lon:)
    @lat = lat
    @lon = lon
    @content ||= JSON.parse(
      Net::HTTP.get_response(URI(url)).body
    ).with_indifferent_access
  end

  def walkscore
    @content[:walkscore]
  end

  alias_method :score, :walkscore

  def to_h
    @content
  end

  def url
    "#{BASE_URL}&lat=#{@lat}&lon=#{@lon}&wsapikey=#{API_KEY}"
  end

end
