module API
  module V1
    class PlaceResource < JSONAPI::Resource

      attributes :name, :place_type, :geometry, :neighborhood_ids

      def place_type
        @model.type
      end

      def geometry
        @model.to_geojson
      end

      def neighborhood_ids
        return [] if @model.type == 'Neighborhood'
        @model.neighborhoods.pluck(:id)
      end

    end
  end
end
