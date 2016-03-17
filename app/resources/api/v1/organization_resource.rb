module API
  module V1
    class OrganizationResource < JSONAPI::Resource

      attributes :name, :website, :location, :email, :short_name, :abbv
      attribute :member_count

      def member_count
        @model.active_members.count
      end

    end
  end
end
