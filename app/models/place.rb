class Place < ActiveRecord::Base
  has_many :developments, dependent: :restrict_with_error
  validates :name, presence: true, length: { maximum: 65 }

  default_scope do
    order("
      CASE
        WHEN type = 'Neighborhood' THEN '1'
        WHEN type = 'Municipality' THEN '2'
        ELSE '3'
      END
    ")
  end

  def self.like(text)
    reverse_scope.where('name ILIKE ?', "#{text}%")
  end

  def self.reverse_scope
    unscope(:order).
    order("
      CASE
        WHEN type = 'Municipality' THEN '1'
        WHEN type = 'Neighborhood' THEN '2'
        ELSE '3'
      END
    ")
  end

  def developments
    Development.within(self.geom)
  end

  def municipality
    case type
    when 'Municipality' then self
    when 'Neighborhood' then place.municipality
    else raise NotImplementedError, "type not defined"
    end
  end

  def neighborhood
    case type
    when 'Neighborhood' then self
    when 'Municipality' then nil
    end
  end

  def updated_since?(timestamp = Time.now)
    return false if developments.empty?
    developments.order(updated_at: :desc).first.updated_since?(timestamp)
  end

  def self.contains(lat: , lon: )
    geo_point = factory.point(lon, lat)
    where('ST_Intersects(geom, :point)', point: geo_point.to_s)
  end

  def to_geojson
    RGeo::GeoJSON.encode geom
  end

  def self.factory
    RGeo::Geographic.spherical_factory(srid: 4326)
  end

  include PgSearch
  multisearchable against: [
    :name,
    :municipality_name,
    :neighborhood_name
  ]

  def municipality_name
    municipality.try :name
  end

  def neighborhood_name
    neighborhood.try :name
  end

end
