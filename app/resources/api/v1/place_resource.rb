module API
  module V1
    class PlaceResource < JSONAPI::Resource

      attributes :name, :place_type

      def place_type
        @model.type
      end

    end
  end
end
