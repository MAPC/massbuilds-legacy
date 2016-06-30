class Development
  module Meta

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Produces a collection of hashes that list every numeric attribute and
      # the current minimum and maximum value.
      def ranged_column_bounds
        Hash[ranged_column_array]
      end

      private

      def ranged_column_array
        columns.map { |c| column_range(c) unless exclude_from_ranges?(c) }.compact
      end

      def column_range(col)
        minmax = {
          max: Development.maximum(col.name),
          min: Development.minimum(col.name)
        }
        [col.name.to_sym, minmax]
      end

      def exclude_from_ranges?(col)
        exclude_reg = /^street_view_|^id$|_id$/
        include_reg = /(integer|double|timestamp|numeric)/i
        exclude_reg.match(col.name.to_s) || !include_reg.match(col.sql_type.to_s)
      end
    end

  end
end
