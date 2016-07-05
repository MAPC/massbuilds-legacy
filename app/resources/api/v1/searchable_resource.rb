require 'mapzen_search'

module API
  module V1
    class SearchableResource < JSONAPI::Resource

      abstract
      key_type :string

      def self.find_by_key(text, options = {})
        search_results = PgSearch.multisearch(text).limit(5).
          map(&:searchable).
          map { |record| wrap_with_resource(record) }
        location = MapzenSearch.new(text).result || null
        if location.properties['confidence'] > 0.75
          search_results.unshift LocationResource.new(location, context: {})
        end
        search_results
      end

      private

      def self.null
        OpenStruct.new(geometry: {}, properties: { 'confidence' => 0 })
      end

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




