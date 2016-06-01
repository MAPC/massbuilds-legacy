module API
  module V1
    class DevelopmentTeamMembershipResource < JSONAPI::Resource
      attribute :role

      has_one :development
      has_one :organization

      paginator :none
    end
  end
end
