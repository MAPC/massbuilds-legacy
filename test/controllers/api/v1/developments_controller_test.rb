require 'test_helper'

class API::V1::DevelopmentsControllerTest < ActionController::TestCase
  def development
    @_development ||= developments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index, filtering on range" do
    get :index, filter: { commsf: '[11,13]' }
    assert_equal 1, results(response).count
    assert_response :success
  end

  test "should get index, filtering on boolean" do
    [{ rdv: 'true' }, { rdv: 'false' }].each do |filter_value|
      get :index, filter: filter_value
      assert_response :success
      assert_equal 0, results(response).count
    end
  end

  test "should log non-blank searches" do
    assert_difference 'Search.count', +2 do
      get :index, filter: { commsf: '[11,13]' }
      get :index, filter: { rdv: 'true' }
    end
  end

  test "should not log blank searches" do
    assert_no_difference 'Search.count' do
      get :index
    end
  end

  test "should get show" do
    get :show, id: development.id
    assert_response :success
  end

  test "should not create, update, or destroy" do
    %i( create update destroy ).each do |action|
      assert_raises(StandardError) { post action }
    end
  end

  private

    def results(response)
      JSON.parse(response.body)['data']
    end

end
