class Development
  module Location

    def location
      [latitude, longitude].map(&:to_f)
    end

    def rlocation
      location.reverse
    end

    def zip_code
      code = read_attribute(:zip_code).to_s
      code.length == 9 ? nine_digit_formatted_zip(code) : code
    end

    def neighborhood
      place.neighborhood if place
    end

    def municipality
      place.municipality if place
    end

    alias_method :city, :municipality

    def parcel
      OpenStruct.new(id: 123)
    end

    def street_view
      @street_view ||= StreetView.new(self)
    end

    def walkscore
      @walkscore ||= WalkScore.new hash: read_attribute(:walkscore)
    end

  end
end
