class WalkScore

  BASE_URL = 'http://api.walkscore.com/score?format=json'.freeze

  attr_reader :content

  # Pass in content if we're trying to wrap and not look up live values.
  # Pass in a lat and lon if we're trying to get a live value.
  def initialize(lat: nil, lon: nil, content: nil)
    @content ||= if content
      content
    else
      @lat, @lon = lat.to_f, lon.to_f
      JSON.parse(response).with_indifferent_access
    end
  end

  def score
    @content['walkscore']
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
    "#{BASE_URL}&lat=#{@lat}&lon=#{@lon}&wsapikey=#{ENV['WALKSCORE_API_KEY']}"
  end

end
