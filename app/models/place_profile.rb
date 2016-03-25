class PlaceProfile < ActiveRecord::Base

  before_save :update_polygon
  before_save :set_response_expiration

  RESPONSE_EXPIRES = 30.days

  validates :latitude,  presence: true,
    numericality: { less_than_or_equal_to: 90, greater_than_or_equal_to: -90 }
  validates :longitude, presence: true,
    numericality: { less_than_or_equal_to: 180, greater_than_or_equal_to: -180 }

  validates :radius,    presence: true

  alias_attribute :x, :longitude
  alias_attribute :y, :latitude

  def to_point
    [x, y]
  end

  def expired?
    expires_at < Time.now
  end

  private

  def update_polygon
    hex = Geometry::RegularPolygon.new(
      edge_count: 6,
      radius: radius,
      center: Geometry::Point[x, y]
    )
    points = hex.points.map { |pt| [pt.x.to_f, pt.y.to_f] }
    self.polygon = { type: 'Polygon', coordinates: [points << points.first] }
  end

  def set_response_expiration
    self.expires_at = RESPONSE_EXPIRES.from_now if response_changed?
  end

end
