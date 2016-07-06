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
    # Array-ify nil caused by a URL error or missing MAPZEN_API_KEY
    Array(JSON.parse(response)['features']).map { |json| OpenStruct.new(json) }
  end

  def response
    Net::HTTP.get_response(URI(@url)).body
  end

  def base
    @base ||= "http://search.mapzen.com/v1/autocomplete"
    @base +=  "?api_key=#{ENV['MAPZEN_API_KEY']}"
    @base +=  "&focus.point.lat=42.357&focus.point.lon=-71.056"
    @base +=  "&sources=openstreetmap"
    @base +=  "&layers=address,microhood,neighbourhood,macrohood"
    @base +=  "&text="
    @base.freeze
  end

end
