require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  def search
    @_search ||= searches(:ranged)
  end

  test 'should get show' do
    get :show, id: search.id, format: :html
    assert_response :success
    assert assigns(:search)
  end

  test 'saves searches when reporting on them' do
    assert_difference 'Search.where(saved: true).count', +1 do
      get :show, id: search.id, format: :html
    end
  end

  test 'renders CSV' do
    get :show, id: search.id, format: :csv
    assert_response :success
    content_type = response.headers['Content-Transfer-Encoding']
    assert_equal 'binary', content_type
  end

end
