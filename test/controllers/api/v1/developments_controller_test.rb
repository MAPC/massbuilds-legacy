require 'test_helper'

class API::V1::DevelopmentsControllerTest < ActionController::TestCase

  def setup
    JSONAPI.configuration.raise_if_parameters_not_allowed = true
  end

  def set_content_type_header!
    @request.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
  end

  def set_auth_header_for_user!(user)
    @request.headers['Authorization'] = "Token #{user.api_key}"
  end

  def user
    @_user ||= users(:normal)
    @_user.create_api_key
    @_user
  end

  def development
    @_development ||= developments(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get index, filtering on range' do
    get :index, filter: { estemp: '[50,100]' }
    assert_equal 1, results(response).count, results(response).inspect
    assert_response :success
  end

  test 'should get index, filtering on boolean' do
    skip
    [{ asofright: 'true' }, { asofright: 'false' }].each do |filter_value|
      get :index, filter: filter_value
      assert_response :success
      assert_equal 0, results(response).count
    end
  end

  test 'should get index, filtering on status' do
    get :index, filter: { status: 'planning' }
    assert_response :success
    assert_equal 1, results(response).count
  end

  test 'should log non-blank searches' do
    assert_difference 'Search.count', +2 do
      get :index, filter: { estemp: '[50,100]' }
      get :index, filter: { rdv: 'true' }
    end
  end

  test 'should not log blank searches' do
    assert_no_difference 'Search.count' do
      get :index
    end
  end

  test 'should handle empty params with grace and poise' do
    get :index, filter: { commsf: '' }
    assert_response :success
    refute_empty results(response), results(response).inspect
  end

  test 'should get show' do
    get :show, id: development.id
    assert_response :success
  end

  test 'should post create' do
    set_auth_header_for_user! user
    set_content_type_header!
    stub_street_view
    stub_walkscore(lat: 42.3, lon: -71.0)
    stub_mbta lat: 42.3, lon: -71.0

    post :create, create_development_json
    assert_response :created, JSON.parse(response.body)#['errors'].first['meta']['backtrace'].join("\n")
  end

  test 'should not create unauthorized user' do
    set_content_type_header!
    post :create, data: create_development_json
    assert_response :unauthorized
  end

  test 'should create edit and return unmodified development' do
    set_content_type_header!
    set_auth_header_for_user! user
    assert_difference 'Edit.pending.count', +1 do
      patch :update, id: developments(:one), data: update_development_payload
    end
    # Shouldn't change the name, since it goes into moderation
    assert_equal 'Godfrey Hotel', results(response)['attributes']['name']
    # Should have the new name in the edit's fields
    assert_includes Edit.last.fields.map(&:change).map(&:to_s).join(' '), '14 Winter Palace'
    assert_includes response.headers['Content-Type'], 'application/vnd.api+json'
    assert_response :success, response.body
  end

  test 'if invalid, should return unmodified development with errors' do
    set_content_type_header!
    set_auth_header_for_user! user
    assert_no_difference 'Edit.pending.count' do
      patch :update, id: developments(:one), data: invalid_update_development_payload
    end
    assert_includes response.body, 'error'
  end

  test 'should not update with unauthorized user' do
    set_content_type_header!
    patch :update, id: developments(:one), data: update_development_payload
    assert_response :unauthorized, response.body
  end

  test 'should not destroy' do
    %i( destroy ).each do |action|
      assert_raises(StandardError) { post action }
    end
  end

  test 'search' do
    skip
    filter_params = { rdv: 'false', clusteros: 'false' }
  end

  private

  def results(response)
    JSON.parse(response.body)['data']
  end

  def create_development_json
    {
      data: {
        type: 'developments',
        attributes: {
          latitude: 42.3,
          longitude: -71.0,
          name: '100 Fury Road',
          description: ('a' * 142),
          'year-compl' => 2106,
          tothu: 0,
          commsf: 0,
          'street-view-latitude'  =>  42.301,
          'street-view-longitude' => -71.010
        }
      }
    }
  end

  def update_development_payload
    {
      type: 'developments',
      id: developments(:one),
      attributes: {
        name: '14 Winter Palace',
        tagline: 'A short, pithy, but long-enough description.',
        'year-compl' => 2016,
        tothu: 10,
        commsf: 1000
      }
    }
  end

  def invalid_update_development_payload
    {
      type: 'developments',
      id: developments(:one),
      attributes: {
        name: '',
        status: 'completed',
        tothu: 10,
        gqpop: 10000,
        commsf: 1000
      }
    }
  end

  def stub_street_view
    file = ActiveRecord::FixtureSet.file('street_view/godfrey.jpg')
    stub_request(:get, 'http://maps.googleapis.com/maps/api/streetview?fov=100&heading=0&key=loLOLol&location=42.301,-71.01&pitch=35&size=600x600').
      to_return(status: 200, body: file)
  end

  def stub_walkscore(lat: 42.000001, lon: -71.000001)
    file = File.read('test/fixtures/walkscore/200.json')
    stub_request(:get, "http://api.walkscore.com/score?format=json&lat=#{lat}&lon=#{lon}&wsapikey=").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'api.walkscore.com', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => file)
  end

  def stub_mbta(lat: 42.000001, lon: -71.000001)
    file = File.read('test/fixtures/mbta/stopsbylocation.json')
    stub_request(:get, "http://realtime.mbta.com/developer/api/v2/stopsbylocation?api_key=&format=json&lat=#{lat}&lon=#{lon}")
      .to_return(status: 200, body: file)
  end

end
