require 'range_parser'

module API
  module V1
    class DevelopmentResource < JSONAPI::Resource
      attributes :name, :status, :description
      attributes :redevelopment, :as_of_right, :age_restricted, :cluster_or_open_space_development
      attributes :description, :address, :city, :state, :zip_code, :full_address

      filter :commsf, apply: ->(records, value, _options) {
        records.where(commsf: RangeParser.parse(value))
      }

      def redevelopment
        @model.rdv
      end

      def as_of_right
        @model.asofright
      end

      def age_restricted
        @model.ovr55
      end

      def cluster_or_open_space_development
        @model.clusteros
      end

      def description
        @model.desc
      end

      def full_address
        "#{@model.address}, #{@model.city} #{@model.state} #{@model.zip_code}"
      end
    end
  end
end
