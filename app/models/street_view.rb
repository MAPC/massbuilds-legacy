class StreetView

  attr_reader :url

  def initialize(source, size: 600)
    @source = source
    @size   = size || defaults.size
    @url    = build_url
  end

  def image(cached: true)
    if cached
      @source.street_view_image ||= fresh_image
    else
      fresh_image
    end
  end

  private

  def fresh_image
    # TODO: Handle timeouts or errors
    Net::HTTP.get_response(URI(@url)).body
  end

  def build_url
    u = "https://maps.googleapis.com/maps/api/streetview?size=#{@size}x#{@size}"
    u << "&location=#{latitude},#{longitude}"
    u << "&fov=#{field_of_view}"
    u << "&heading=#{heading}"
    u << "&pitch=#{pitch}"
    u << "&key=#{ENV['GOOGLE_API_KEY']}"
  end

  def latitude
    # I'm not proud of this.
    @source.street_view_latitude || @source.latitude || defaults.latitude
  rescue
    defaults.latitude
  end

  def longitude
    @source.street_view_longitude || @source.longitude || defaults.longitude
  rescue
    defaults.longitude
  end

  def heading
    @source.street_view_heading || defaults.heading
  end

  def pitch
    @source.street_view_pitch || defaults.pitch
  end

  def field_of_view
    defaults.fov
  end

  def defaults
    OpenStruct.new(
      latitude: 42.3547661,
      longitude: -71.0615689,
      size: 600,
      pitch: 28,
      heading: 35,
      fov: 100
    )
  end

end
