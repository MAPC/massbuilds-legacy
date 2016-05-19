class Development
  module Validations
    extend ActiveSupport::Concern

    included do

      validates :tothu,  presence: true
      validates :commsf, presence: true
      validates :creator,    presence: true
      validates :year_compl, presence: true
      validates :tagline,     allow_blank: true, length: { minimum: 40,  maximum: 140 }
      validates :description, allow_blank: true, length: { minimum: 141, maximum: 500 }

      lat_range = { less_than_or_equal_to:  90, greater_than_or_equal_to:  -90 }
      lon_range = { less_than_or_equal_to: 180, greater_than_or_equal_to: -180 }

      validates :latitude,  presence: true, numericality: lat_range
      validates :longitude, presence: true, numericality: lon_range

      validates :street_view_latitude,  allow_blank: true, numericality: lat_range
      validates :street_view_longitude, allow_blank: true, numericality: lon_range

    end
  end
end
