class Development
  module Location

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def within_box(top: , right: , bottom: , left: )
        factory = RGeo::Geographic.spherical_factory
        sw = factory.point(left, bottom)
        ne = factory.point(right, top)
        window = RGeo::Cartesian::BoundingBox.create_from_points(sw, ne).to_geometry
        where("point && ?", window)
      end

      def within(geometry)
        where("ST_Intersects(point, ?)", geometry.to_s.presence)
      end
    end

    def location
      [latitude, longitude].map(&:to_f)
    end

    def rlocation
      location.reverse
    end

    def to_geojson
      RGeo::GeoJSON.encode point
    end

    def zip_code
      code = read_attribute(:zip_code).to_s
      code.length == 9 ? nine_digit_formatted_zip(code) : code
    end

    def neighborhood
      place.neighborhood if place
    end

    def municipality
      place.municipality if place
    end

    alias_method :city, :municipality

    def parcel
      OpenStruct.new(id: 123)
    end

    def street_view
      @street_view_client
    end

    # In tests, we can set the clients for external services to fakes.
    attr_writer :nearest_transit_client, :street_view_client, :walkscore_client

    def nearest_transit_client
      @nearest_transit_client ||= NearestTransit.new(lat: self.latitude, lon: self.longitude)
    end

    def street_view_client
      @street_view_client ||= StreetView.new(self)
    end

    def walkscore_client
      @walkscore_client ||= WalkScore.new(self)
    end

  end
end
