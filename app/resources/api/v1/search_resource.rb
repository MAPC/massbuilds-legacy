module API
  module V1
    class SearchResource < JSONAPI::Resource
      attributes :query, :saved, :user_id
      # TODO once resource is present => has_one :user
    end
  end
end
