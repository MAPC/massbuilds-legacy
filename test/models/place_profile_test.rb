require 'test_helper'

class PlaceProfileTest < ActiveSupport::TestCase

  def place_profile
    @place_profile ||= place_profiles :one
  end
  alias_method :profile, :place_profile

  def geojson
    {
      'type' => 'Polygon',
      'coordinates' => [
        [
          [1.0,                  0.0],
          [0.5000000000000001,   0.8660254037844386],
          [-0.4999999999999998,  0.8660254037844388],
          [-1.0,                 1.224646799147353e-16],
          [-0.5000000000000004, -0.8660254037844384],
          [0.4999999999999993,  -0.866025403784439],
          [1.0,                  0.0]
        ]
      ]
    }
  end

  test 'valid' do
    assert profile.valid?
  end

  test 'requires a center point' do
    profile.latitude = profile.longitude = nil
    assert_not profile.valid?
  end

  test 'requires a reasonable latitude' do
    [90.00000000000001, -90.00000000000001].each do |pt|
      profile.latitude = pt
      assert_not profile.valid?
    end
    profile.latitude = 0
    assert profile.valid?
  end

  test 'requires a reasonable longitude' do
    [180.0000000000001, -180.0000000000001].each do |pt|
      profile.longitude = pt
      assert_not profile.valid?
    end
    profile.longitude = 0
    assert profile.valid?
  end

  test 'requires a radius' do
    profile.radius = nil
    assert_not profile.valid?
  end

  test '#to_point' do
    profile.longitude = 10
    profile.latitude  = 20
    assert_equal [10, 20], profile.to_point
  end

  test 'coordinates equal named attributes' do
    profile.longitude = profile.x
    profile.latitude  = profile.y
  end

  test '#polygon builds a geojson hexagon around the center point' do
    profile.x = profile.y = 0
    profile.radius = 1
    profile.save
    assert_equal geojson['type'], profile.polygon['type']

    # See if the coordinates are within a ridiculously small
    # tolerance. Testing equality results in very slightly
    # different rounding on the continuous integration platform.
    geo_coords  = geojson['coordinates'].flatten
    poly_coords = profile.polygon['coordinates'].flatten
    geo_coords.each_with_index { |coord, i|
      assert_in_delta coord, poly_coords[i], 0.00000000000001
    }
  end

  test 'gets information from KnowPlace' do
    skip """
      - Need VCR, or equivalent, or a mock response.
      - Need KnowPlace to be in a certain state to receive this.
    """
  end

  test '#expired?' do
    profile.expires_at = 10.minutes.from_now
    assert_not profile.expired?
    profile.expires_at = 10.minutes.ago
    assert profile.expired?
  end

  test 'sets expiration when saves a response' do
    profile.expires_at = 10.minutes.ago
    profile.response = {}
    profile.save
    assert profile.expires_at > 10.days.from_now, profile.expires_at
  end

  test 'checks expiration on intialization' do
    #   When the model is loaded from the database, an
    #   after_find hook checks to see if Time.now is past the
    #   model's expiration date. It sets expired to TRUE, and maybe
    #   some other actions.
    profile.expires_at = 10.minutes.ago
    assert profile.expired?
  end
end
