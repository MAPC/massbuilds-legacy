class WalkScore

  BASE_URL = 'http://api.walkscore.com/score?format=json'.freeze
  API_KEY = ENV['WALKSCORE_API_KEY']

  def initialize(lat: nil, lon: nil, hash: {})
    @content ||= if hash
      hash
    else
      @lat, @lon = lat, lon
      JSON.parse(response).with_indifferent_access
    end
  end

  def score
    @content[:walkscore]
  end

  def to_h
    @content
  end

  def empty?
    @content.keys.count <= 1 # Status key is always present
  end

  def response
    Net::HTTP.get_response(URI(url)).body
  end

  def url
    "#{BASE_URL}&lat=#{@lat}&lon=#{@lon}&wsapikey=#{API_KEY}"
  end

end
