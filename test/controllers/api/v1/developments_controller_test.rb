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
    get :index, filter: { commsf: '[11,13]' }
    assert_equal 1, results(response).count, results(response).inspect
    assert_response :success
  end

  test 'should get index, filtering on boolean' do
    [{ asofright: 'true' }, { asofright: 'false' }].each do |filter_value|
      get :index, filter: filter_value
      assert_response :success
      assert_equal 0, results(response).count
    end
  end

  test 'should get index, filtering on status' do
    get :index, filter: { status: 'in_construction' }
    assert_response :success
    assert_equal 1, results(response).count
  end

  test 'should log non-blank searches' do
    assert_difference 'Search.count', +2 do
      get :index, filter: { commsf: '[11,13]' }
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

  focus
  test 'should post create' do
    set_auth_header_for_user! user
    set_content_type_header!
    post :create, {
      data: {
        type: 'developments',
        attributes: {
          latitude: 42.3,
          longitude: -71.0,
          name: 'heyo listen what I sayo',
          'year-compl' => 2106,
          'street-view-longitude' => 42.301,
          'street-view-latitude' => -71.010
        }
      }
    }
    assert_response :created, response.body
  end

  test 'should not create unauthorized user' do
    set_content_type_header!
    post :create, data: create_development_json
    assert_response :unauthorized
  end

  test 'should not create, update, or destroy' do
    %i( update destroy ).each do |action|
      assert_raises(StandardError) { post action }
    end
  end

  private

  def results(response)
    JSON.parse(response.body)['data']
  end

  def create_development_json
    {
      type: 'developments',
      attributes: {
        latitude: 42.34112697262291,
        longitude: -71.08826943770919,
        prjarea: nil,
        name: nil,
        address: "32",
        city: "Boston",
        commsf: nil,
        tothu: nil,
        year_compl: 2016,
        description: nil,
        street_view_latitude: 42.341578992156656,
        street_view_longitude: -71.08757742778562
      }
    }
  end

end
