module API
  module V1
    class DevelopmentTeamMembershipResource < JSONAPI::Resource
      attribute :role
      has_one :organization
    end
  end
end
