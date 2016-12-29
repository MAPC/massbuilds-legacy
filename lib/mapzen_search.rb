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
    results.first
  end

  private

  def results
    # Array-ify nil caused by a URL error
    Array(JSON.parse(response)['features']).map { |json| OpenStruct.new(json) }
  end

  def response
    Net::HTTP.get_response(URI(@url)).body
  end

  def base
    @base ||= %W(
      http://search.mapzen.com/v1/search
      ?api_key=#{ENV.fetch('MAPZEN_API_KEY')}
      &focus.point.lat=42.357&focus.point.lon=-71.056
      &sources=openstreetmap
      &layers=address,microhood,neighbourhood,macrohood
      &text=
    ).join.freeze
  end

end
