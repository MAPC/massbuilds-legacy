require 'test_helper'

class WalkScoreTest < ActiveSupport::TestCase

  def ws
    @_ws ||= WalkScore.new(resource)
  end

  def resource
    Development.new(latitude: 42.2, longitude: -71.1, walkscore: {})
  end

  def with_score
    @_with ||= WalkScore.new(scored_resource)
  end

  def scored_resource
    Development.new(latitude: 42.2, longitude: -71.1, walkscore: {'score' => 97})
  end

  test 'get on a new development' do
    stub_walkscore
    assert_empty ws.content
    ws.get
    assert_not_empty ws
  end

  private

  def stub_walkscore(lat: 42.2, lon: -71.1)
    file = File.read('test/fixtures/walkscore/200.json')
    stub_request(:get, "http://api.walkscore.com/score?format=json&lat=#{lat}&lon=#{lon}&wsapikey=").
      with(:headers => {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Host'=>'api.walkscore.com',
        'User-Agent'=>'Ruby'
        }
      ).
      to_return(:status => 200, :body => file)
  end


end
