require 'test_helper'

class DevelopmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    skip "Pending"
    get :show
    assert_response :success
  end

end
