class Development
  module Validations
    extend ActiveSupport::Concern

    include Development::FieldAliases

    included do

      validates :tothu,      presence: true
      validates :commsf,     presence: true
      validates :year_compl, presence: true

      validates :creator,    presence: true

      validates :tagline,
                allow_blank: true,
                length: { minimum: 11,  maximum: 140 }

      validates :description,
                allow_blank: true,
                length: { minimum: 30, maximum: 500 }

      # Advanced information

      with_options if: :requires_detailed_housing? do |record|
        Development::HOUSING_FIELDS.each do |attribute|
          record.validates attribute, presence: true, numericality: { minimum: 0 }
        end
      end

      with_options if: :requires_detailed_nonres? do |record|
        Development::COMMERCIAL_FIELDS.each do |attribute|
          record.validates attribute, presence: true, numericality: { minimum: 0 }
        end
      end

      validate :housing_units_equal_total_coerced,   if: :requires_detailed_housing?
      validate :commercial_sqft_equal_total_coerced, if: :requires_detailed_nonres?

      # Location

      lat_range = {
        less_than_or_equal_to:     90,
        greater_than_or_equal_to: -90
      }

      lon_range = {
        less_than_or_equal_to:     180,
        greater_than_or_equal_to: -180
      }

      validates :latitude,  presence: true, numericality: lat_range
      validates :longitude, presence: true, numericality: lon_range

      validates :street_view_latitude,
                allow_blank:  true,
                numericality: lat_range

      validates :street_view_longitude,
                allow_blank:  true,
                numericality: lon_range

      private

      def requires_detailed_housing?
        (in_construction? || completed?) && tothu.to_i > 0
      end

      def requires_detailed_nonres?
        (in_construction? || completed?) && commsf.to_i > 0
      end

      def housing_units_equal_total_coerced
        if housing_unit_values.map(&:to_i).reduce(:+) != tothu
          errors.add(:tothu, 'must equal the sum of unit types')
        end
      end

      def commercial_sqft_equal_total_coerced
        if commercial_area_values.map(&:to_i).reduce(:+) != commsf
          errors.add(:commsf, 'must equal the sum of floor area types')
        end
      end

      def housing_unit_values
        [singfamhu, twnhsmmult, lgmultifam]
      end

      def commercial_area_values
        Development::COMMERCIAL_FIELDS.map { |field| self.send(field) }
      end

    end
  end
end
