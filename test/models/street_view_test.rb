require 'test_helper'

class StreetViewTest < ActiveSupport::TestCase

  test 'never raises, has default URL' do
    assert_equal expected_default_url, StreetView.new(Development.new).url
  end

  test 'given a development, builds a url' do
    assert_equal expected_url, StreetView.new(developments(:one)).url
  end

  test 'given a size, builds a url' do
    assert_equal sized_url, StreetView.new(developments(:one), size: 300).url
  end

  test 'fresh image' do
    file = ActiveRecord::FixtureSet.file('street_view/godfrey.jpg')
    stub_request(:get, 'http://maps.googleapis.com/maps/api/streetview?fov=100&heading=35&key=loLOLol&location=43.000001,70.000001&pitch=28&size=600x600').
      to_return(status: 200, body: file)
    assert StreetView.new(developments(:two)).image.present?
  end

  test 'no fresh image' do
    skip
    # This may not be a useful test.
    stub_request(:get, 'http://maps.googleapis.com/maps/api/streetview?fov=100&heading=35&key=loLOLol&location=43.000001,70.000001&pitch=28&size=600x600').
      to_return(status: 200, body: '')
    refute StreetView.new(developments(:two)).image.present?
  end

  test 'width and height' do
    actual = StreetView.new(developments(:one), width: 70, height: 80).url
    assert_equal width_height_url, actual
  end

  def expected_default_url
    expected = 'http://maps.googleapis.com/maps/api/streetview?size=600x600'
    expected << '&location=42.3547661,-71.0615689&fov=100&heading=0&pitch=35'
    expected << '&key=loLOLol'
  end

  def expected_url
    expected = 'http://maps.googleapis.com/maps/api/streetview?size=600x600'
    expected << '&location=42.000001,71.000001&fov=100&heading=235&pitch=35'
    expected << '&key=loLOLol'
  end

  def sized_url
    expected = 'http://maps.googleapis.com/maps/api/streetview?size=300x300'
    expected << '&location=42.000001,71.000001&fov=100&heading=235&pitch=35'
    expected << '&key=loLOLol'
  end

  def width_height_url
    expected = 'http://maps.googleapis.com/maps/api/streetview?size=70x80'
    expected << '&location=42.000001,71.000001&fov=100&heading=235&pitch=35'
    expected << '&key=loLOLol'
  end
end
