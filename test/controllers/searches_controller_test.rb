require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  def search
    @_search ||= searches(:ranged)
  end

  test 'should get show' do
    get :show, id: search.id
    assert_response :success
    assert assigns(:search)
  end

  test 'saves searches when reporting on them' do
    assert_difference 'Search.where(saved: true).count', +1 do
      get :show, id: search.id
    end
  end

end
