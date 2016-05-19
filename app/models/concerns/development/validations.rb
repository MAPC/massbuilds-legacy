class Development
  module Validations
    extend ActiveSupport::Concern

    included do

      validates :tothu,      presence: true
      validates :commsf,     presence: true
      validates :year_compl, presence: true

      validates :creator,    presence: true

      validates :tagline,
                allow_blank: true,
                length: { minimum: 40,  maximum: 140 }

      validates :description,
                allow_blank: true,
                length: { minimum: 141, maximum: 500 }

      # Advanced information

      with_options if: :requires_detailed_housing? do |record|
        [:singfamhu, :twnhsmmult, :lgmultifam, :gqpop].each do |attribute|
          record.validates attribute, presence: true, numericality: { minimum: 0 }
        end
      end

      with_options if: :requires_detailed_nonres? do |record|
        [
          :fa_ret,   :fa_ofcmd, :fa_indmf,
          :fa_whs,   :fa_rnd,   :fa_edinst,
          :fa_other, :fa_hotel
        ].each do |attribute|
          record.validates attribute, presence: true, numericality: { minimum: 0 }
        end
      end

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

    end
  end
end
