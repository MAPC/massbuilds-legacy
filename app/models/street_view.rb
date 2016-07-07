require 'compass'

class StreetView

  attr_reader :url

  def initialize(source, width: nil, height: nil, size: 600)
    @source = source
    @width  = width || height || size
    @height = height || width || size
    @url    = build_url
  end

  def image(cached: true)
    if cached
      @source.street_view_image ||= fresh_image
    else
      fresh_image
    end
  end

  def data
    "data:image/jpg;base64,#{Base64.encode64(image)}"
  end

  # Perform a checksum on the image
  def hash
    Digest::MD5.hexdigest image
  end

  def null?
    self.class.null.include? hash
  end

  # This image means we're over the rate limit.
  def self.null
    [
      "18bd8a05483bcc612f0891f94364d410",  # Rate-limited
      "f4af83d510a83d5c480ecebe1cedaf6d",  # No imagery here
      "4346be5ac59a41baeeb8eaffd43e4a59"   # API server rejected your request
    ]
  end

  def compass_direction
    Compass.direction_from_degrees(heading)
  end

  private

  def fresh_image
    # TODO: Handle timeouts or errors
    Net::HTTP.get_response(URI(@url)).body
  rescue
    ""
  end

  def build_url
    u =  "http://maps.googleapis.com/maps/api/streetview?"
    u << "size=#{@width}x#{@height}"
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
