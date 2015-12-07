require 'test_helper'

class DevelopmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get _development" do
    get :_development
    assert_response :success
  end

end
