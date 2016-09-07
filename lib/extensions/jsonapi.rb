module JSONAPI

  class Resource
    class << self
      def range_filters(*filter_attributes)
        Array(filter_attributes).flatten.each do |attribute|
          filter(attribute, apply: ->(records, values, options) {
            records.where(attribute => RangeParser.parse(values))
          })
        end
      end

      def boolean_filters(*filter_attributes)
        Array(filter_attributes).flatten.each do |attribute|
          filter(attribute, apply: ->(records, values, options) {
            records.where(attribute => values.map(&:to_b))
          })
        end
      end

      alias_method :range_filter,   :range_filters
      alias_method :boolean_filter, :boolean_filters
    end
  end


  class LinkBuilder
    private

    def formatted_module_path_from_class(klass)
      '/'
    end
  end
end
