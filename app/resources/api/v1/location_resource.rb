module API
  module V1
    class LocationResource < JSONAPI::Resource

      abstract
      key_type :string

      attributes :geometry, :properties

    end
  end
end
