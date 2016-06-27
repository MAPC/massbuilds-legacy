module API
  module V1
    class SearchableResource < JSONAPI::Resource

      abstract
      key_type :string

      def self.find_by_key(id, options = {})
        PgSearch.multisearch(id).limit(5).
          map(&:searchable).
          map { |record| wrap_with_resource(record) }
      end

      private

      def self.wrap_with_resource(record)
        case record.class.name
        when 'Development'
          DevelopmentResource.new(record, context: {})
        when 'Place', 'Municipality', 'Neighborhood'
          PlaceResource.new(record, context: {})
        else
          raise ArgumentError, "invalid record class #{record.class.name}"
        end
      end

    end
  end
end
