module JSONAPI

  class Resource
    class << self
      def range_filters(*filter_attributes)
        Array(filter_attributes).flatten.each { |attribute|
          filter(attribute, apply: ->(records, value, options) {
            records.where(attribute => RangeParser.parse(value))
          })
        }
      end

      def boolean_filters(*filter_attributes)
        Array(filter_attributes).flatten.each { |attribute|
          filter(attribute, apply: ->(records, value, options) {
            if [false, nil].include? value.first.to_b
              records.where(attribute => [false, nil])
            else
              records.where(attribute => true)
            end
          })
        }
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
