module API
  module V1
    class OrganizationResource < JSONAPI::Resource

      attributes :name, :website, :location, :email, :short_name, :abbv,
                 :logo, :member_count

      def member_count
        @model.active_members.count
      end

      filter :search, apply: -> (records, values, options) {
        records.search values.first
      }
    end
  end
end
