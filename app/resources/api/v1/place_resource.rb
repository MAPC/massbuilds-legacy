module API
  module V1
    class PlaceResource < JSONAPI::Resource

      attributes :name, :type

    end
  end
end
