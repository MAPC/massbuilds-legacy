require 'mapzen_search'

module API
  module V1
    class SearchableResource < JSONAPI::Resource

      abstract
      key_type :string

      def self.find_by_key(text, options = {})
        search_results = PgSearch.multisearch(text).
          where(searchable_type: 'Development').limit(5).
          map(&:searchable).
          map { |record| wrap_with_resource(record) }
        loc = MapzenSearch.new(text).result || null
        search_results.unshift place_resource(text) if no_place?(search_results)
        search_results.unshift location_resource(loc) if confident_in_location?(loc)
        search_results
      end

      private

      def self.location_resource(location)
        LocationResource.new(location, context: {})
      end

      def self.confident_in_location?(location)
        location.properties['confidence'] > 0.75
      end

      def self.place_resource(text)
        PlaceResource.new(
          Place.like(text).first, context: {}
        )
      end

      def self.no_place?(search_results)
        search_results.select { |r| r.is_a?(PlaceResource) }.empty?
      end

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




