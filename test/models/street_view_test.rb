require 'test_helper'

class StreetViewTest < ActiveSupport::TestCase

  test 'basic attributes' do
    subject = StreetView.new(Development.new)
    assert_respond_to subject, :url
    assert_respond_to subject, :image
  end

  test 'never raises, has default URL' do
    assert_equal street_view_url, StreetView.new(Development.new).url
  end

  test 'given a development, builds a url' do
    expected = street_view_url(lat: 42.000001, lon: 71.000001, heading: 235)
    actual = StreetView.new(developments :one).url
    assert_equal expected, actual
  end

  test 'given a size, builds a url' do
    expected = street_view_url(
      lat: 42.000001,
      lon: 71.000001,
      heading: 235,
      size: '300x300'
    )
    actual = StreetView.new(developments(:one), size: 300).url
    assert_equal expected, actual
  end

  test 'fresh image' do
    file = ActiveRecord::FixtureSet.file('street_view/godfrey.jpg')
    svu = street_view_url(lat: 43.000001, lon: 70.000001, pitch: 28, heading: 35)
    stub_request(:get, svu).to_return(status: 200, body: file)
    assert StreetView.new(developments(:two)).image.present?
  end

  test 'no fresh image' do
    development = developments(:two)
    development.street_view_image = nil
    subject = StreetView.new(development)
    svu = street_view_url(lat: 43.000001, lon: 70.000001, pitch: 35, heading: 0)
    stub_request(:get, svu).to_return(status: 200, body: '')
    refute subject.image.present?, "----> #{subject.image.inspect}"
  end

  test 'width and height' do
    expected = street_view_url(
      lat: 42.000001,
      lon: 71.000001,
      heading: 235,
      size: '70x80'
    )
    actual = StreetView.new(developments(:one), width: 70, height: 80).url
    assert_equal expected, actual
  end

  def street_view_url(lat: 42.3547661, lon: -71.0615689, heading: 0, pitch: 35, size: '600x600')
    %W(
      http://maps.googleapis.com/maps/api/streetview?size=#{size}
      &location=#{lat},#{lon}&fov=100&heading=#{heading}&pitch=#{pitch}
      &key=loLOLol
    ).join
  end
end
