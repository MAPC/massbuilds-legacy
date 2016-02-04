require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  def search
    @_search ||= searches(:ranged)
  end

  test "should get show" do
    get :show, id: search.id
    assert_response :success
    assert assigns(:search)
  end

end
