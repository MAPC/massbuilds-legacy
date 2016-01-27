require 'test_helper'

class SearchesControllerTest < ActionController::TestCase

  def search
    @_search ||= searches(:ranged)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: search.id
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should post create with a signed-in user" do
    sign_in users(:normal)
    post :create, search: { commsf: [1,10] }
    assert_response :success
  end

  test "should post create with an anonymous user" do
    skip "Have yet to implement Anonymous Users"
    post :create, search: { commsf: [1,10] }
    assert_response :success
  end

end
