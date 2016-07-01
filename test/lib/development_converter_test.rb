require 'test_helper'

require 'development_converter'

class DevelopmentConverterTest < ActiveSupport::TestCase

  def setup
    stub_geocoder
  end

  def development
    @_development ||= Development.new(
      DevelopmentConverter.new(row).to_h
    )
  end

  def row
    CSV.read(fixture_file, headers: true, converters: :all).first
  end

  alias_method :d, :development

  def test_development_valid
    assert development.valid?, development.errors.full_messages
  end

  def test_lat_lon
    assert_equal 'POINT(-71.0462 42.4122999999998)', row['location']
    assert_equal [-71.0462, 42.4122999999998], DevelopmentConverter.new(row).location
    assert_equal 42.4123, development.latitude.to_f
    assert_equal -71.0462, development.longitude.to_f
  end

  def test_convert_floor_areas
    expected = {
      fa_ret:     50,
      fa_ofcmd:  100,
      fa_indmf:  150,
      fa_whs:    200,
      fa_rnd:    220,
      fa_edinst: 280,
      fa_other:    0
    }
    assert_hash expected
  end

  def test_location
    expected = {
      latitude:   42.4123,
      longitude: -71.0462,
      street_view_latitude:   42.4123,
      street_view_longitude: -71.0462,
      street_view_heading:     0,
      street_view_pitch:      35
    }
    assert_hash_float expected
  end

  def test_updated_timestamp_persists
    stub_street_view
    stub_walkscore lat: 42.4123, lon: -71.0462
    stub_mbta lat: 42.4123, lon: -71.0462
    assert 1.minute.ago > d.updated_at
    d.save!
    assert 1.minute.ago > d.updated_at
  end

  def test_convert_from_csv
    skip 'failing'
    CSV.foreach(fixture_file, headers: true, converters: :all) do |row|
      loc = row['location'].delete('POINT(').delete(')').split(' ')
      lat = loc.last
      lon = loc.first
      stub_geocoder(lat: lat, lon: lon)
      dev = Development.new(DevelopmentConverter.new(row).to_h)
      assert dev.valid?, dev.errors.full_messages
    end
  end

  private

  def fixture_file
    './test/fixtures/csvs/developments.csv'
  end

  def assert_hash(hash)
    hash.each_pair do |key, expected_value|
      assert_equal expected_value, d.send(key)
    end
  end

  def assert_hash_float(hash)
    hash.each_pair do |key, expected_value|
      assert_equal expected_value, d.send(key).to_f
    end
  end

  def stub_geocoder(lat: 42.4122999999998, lon: -71.0462)
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?language=en&latlng=#{lat},#{lon}&sensor=false").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(
        :status => 200,
        :body => File.read('./test/fixtures/geocoder/200.json'),
        :headers => {'Content-Type' => 'application/json'}
      )
  end

  def stub_street_view
    stub_request(:get, "http://maps.googleapis.com/maps/api/streetview?fov=100&heading=0&key=loLOLol&location=42.4123,-71.0462&pitch=35&size=600x600")
  end

  def stub_walkscore(lat: 42.000001, lon: -71.000001)
    file = File.read('test/fixtures/walkscore/200.json')
    stub_request(:get, "http://api.walkscore.com/score?format=json&lat=#{lat}&lon=#{lon}&wsapikey=").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'api.walkscore.com', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => file)
  end

  def stub_mbta(lat: 42.000001, lon: 71.000001)
    file = File.read('test/fixtures/mbta/stopsbylocation.json')
    stub_request(:get, "http://realtime.mbta.com/developer/api/v2/stopsbylocation?api_key=&format=json&lat=#{lat}&lon=#{lon}")
      .to_return(status: 200, body: file)
  end


end
