class MapzenSearch

  attr_reader :id

  def initialize(text)
    @text = text
    @url  = base + text
  end

  def id
    @text
  end

  def geometry
    {
      type:        result['type'],
      coordinates: result['geometry'],
      properties:  result['properties']
    }
  end

  def result
    results.last
  end

  private

  def results
    # Array-ify nil caused by a URL error
    parsed_response = Array(JSON.parse(response)['features'])
    parsed_response.sort! { |result| result["properties"]["confidence"] }
    parsed_response.map { |json| OpenStruct.new(json) }
  end

  def response
    Net::HTTP.get_response(URI(@url)).body
  end

  def base
    @base ||= %W(
      http://search.mapzen.com/v1/search
      ?api_key=#{ENV.fetch('MAPZEN_API_KEY')}
      &focus.point.lat=42.357&focus.point.lon=-71.056
      &text=
    ).join.freeze
  end

end
