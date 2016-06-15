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
      @walkscore ||= WalkScore.new content: read_attribute(:walkscore)
    end

    def get_walkscore
      self.walkscore = WalkScore.new(lat: latitude, lon: longitude).to_h
    end

    def get_nearest_transit
      key = 'parent_station_name'

      url = "http://realtime.mbta.com/developer/api/v2/stopsbylocation?"
      url << "api_key=#{ENV['MBTA_API_KEY']}"
      url << "&lat=#{latitude.to_f}&lon=#{longitude.to_f}&format=json"

      puts url

      json = JSON.parse(Net::HTTP.get_response(URI(url)).body)

      station = json['stop'].detect { |e| e[key].present? }
      name = if station
        station[key]
      else
        "Bus stop: #{json['stop'].first['stop_name']}"
      end
      self.nearest_transit = name
    rescue StandardError => e
      self.nearest_transit = "" # Return current value or empty string
    end

  end
end
