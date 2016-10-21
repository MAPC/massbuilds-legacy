require 'test_helper'

require 'development_converter'

class DevelopmentConverterTest < ActiveSupport::TestCase

  include ExternalServices::Fakes

  FIXTURE_FILE = './test/fixtures/csvs/developments.csv'

  def setup
    stub_geocoder
  end

  def development
    @_development ||= mock_out(Development.new(DevelopmentConverter.new(row).to_h))
  end

  def row
    CSV.read(FIXTURE_FILE, headers: true, converters: :all).first
  end

  alias_method :d, :development

  test 'valid' do
    assert development.valid?, development.errors.full_messages
  end

  test 'lat and lon' do
    assert_equal 'POINT(-71.0462 42.4122999999998)', row['location']
    assert_equal [-71.0462, 42.4122999999998], DevelopmentConverter.new(row).location
    assert_equal 42.4123, development.latitude.to_f
    assert_equal -71.0462, development.longitude.to_f
  end

  test 'convert_floor_areas' do
    expected = {
      fa_ret:     50,
      fa_ofcmd:  100,
      fa_indmf:  150,
      fa_whs:    200,
      fa_rnd:    220,
      fa_edinst: 280,
      fa_other:    0
    }
    expected.each_pair do |key, expected_value|
      assert_equal expected_value, d.send(key)
    end
  end

  test 'location' do
    expected = {
      latitude:   42.4123,
      longitude: -71.0462,
      street_view_latitude:   42.4123,
      street_view_longitude: -71.0462,
      street_view_heading:     0,
      street_view_pitch:      35
    }
    expected.each_pair do |key, expected_value|
      assert_equal expected_value, d.send(key)
    end
  end

  test 'updated_timestamp_persists' do
    # Make sure that when we save this record, we're using the value of 'updated_at'
    # that we're converting from, and not setting it to right now.
    assert 1.minute.ago > d.updated_at
    d.save!
    assert 1.minute.ago > d.updated_at
  end

  def test_keeps_original_id
    stub_geocoder
    dev = mock_out(Development.new(DevelopmentConverter.new(row, id: true).to_h))
    assert_equal 3665, dev.id
    dev.save!(validate: false)
    dev.reload
    assert_equal 3665, dev.id
  ensure
    dev.destroy if dev
  end

  test 'row_without_id' do
    dev = Development.new(DevelopmentConverter.new(row, id: false).to_h)
    assert_equal nil, dev.id
  end

  test 'programs' do
    expected = ["40B"]
    assert_equal development.programs, expected
  end

  private

  def stub_geocoder(lat: 42.4122999999998, lon: -71.0462)
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?language=en&latlng=#{lat},#{lon}&sensor=false").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(
        :status => 200,
        :body => File.read('./test/fixtures/geocoder/200.json'),
        :headers => {'Content-Type' => 'application/json'}
      )
  end

end
