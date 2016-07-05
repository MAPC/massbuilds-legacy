module API
  module V1
    class PlaceResource < JSONAPI::Resource

      attributes :name, :place_type, :geometry

      def place_type
        @model.type
      end

      def geometry
        @model.to_geojson
      end

    end
  end
end
