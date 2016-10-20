class NearestTransit

  SUBWAY_KEY = 'parent_station_name'

  def initialize(lat: , lon: )
    @lat = lat
    @lon = lon
  end

  def get
    stop_name
  end

  private

  def stop_name
    subway_station || bus_sotp
  end

  def subway_station
    # If the 'subway_station_name' attribute is present in the JSON, it means
    # it is a subway station.
    if subway = stops.detect { |e| e[SUBWAY_KEY].present? }
      subway[SUBWAY_KEY]
    end
  end

  def bus_stop
    "Bus stop: #{ stops.first['stop_name'] }"
  end

  def stops
    # Write a client that gets stops, raises if there's a server error,
    # and returns the stop information.
    @stops ||= client.stops_by_location(lat: @lat, lon: @lon)['stop']
  end

  def client
    client ||= MBTARealtime::Client.new(api_key: ENV['MBTA_API_KEY'])
  end

end
