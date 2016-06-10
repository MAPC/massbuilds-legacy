require 'test_helper'

class API::V1::SearchesControllerTest < ActionController::TestCase
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

  def wrong_user
    @_user ||= users(:tim)
    @_user.create_api_key
    @_user
  end

  def search
    @_search ||= searches(:saved)
  end

  test 'index requires a user' do
    get :index
    assert_response :unauthorized

    set_auth_header_for_user!(user)
    get :index
    assert_response :success
  end

  test "index will return the current user's searches" do
    expected_ids = user.searches.map(&:id)
    set_auth_header_for_user!(user)
    get :index
    actual_ids = JSON.parse(response.body)['data'].map{ |r| r['id'].to_i}
    assert_equal expected_ids, actual_ids
  end

  test 'show' do
    set_auth_header_for_user!(user)
    get :show, id: search.id
    assert_response :success
    %w( id query saved ).each { |i|
      assert_includes response.body, i
    }
  end

  test "show will not display another user's search" do
    someone_elses_search = searches(:saved_for_someone_else)
    set_auth_header_for_user!(user)
    get :show, id: someone_elses_search.id
    assert_response :not_found
  end

  test 'create with user authorized through header' do
    set_content_type_header!
    set_auth_header_for_user!(user)
    post :create, empty_saved_search
    assert_response :created, response.body
  end

  test 'create with user authorized through data param' do
    set_content_type_header!
    assert_difference 'Search.count', +1 do
      post :create, empty_saved_search.merge({ api_key: user.api_key.token })
    end
    assert_response :created, response.body
  end

  test 'create does not save pagination parameters' do
    set_content_type_header!
    set_auth_header_for_user!(user)
    post :create, search_with_page_parameters
    assert_response :created, response.body
    query_keys = results(response)['attributes']['query'].keys
    refute query_keys.include?('number'), query_keys.inspect
  end

  test 'create with no user' do
    set_content_type_header!
    post :create, empty_unsaved_search
    assert_response :unauthorized, response.body
  end

  test 'destroy a search' do
    set_content_type_header!
    set_auth_header_for_user!(user)
    assert_difference 'Search.count', -1 do
      delete :destroy, id: search.id
    end
    assert_response :success, response.body
  end

  test 'destroy with wrong user' do
    set_content_type_header!
    set_auth_header_for_user!(wrong_user)
    delete :destroy, id: searches(:ranged).id
    # Instead of returning :unauthorized, returns :not_found because the records
    # are only those belonging to current_user.
    assert_response :not_found, response.body
  end

  test 'destroy with no user' do
    set_content_type_header!
    delete :destroy, id: search.id
    assert_response :unauthorized, response.body
  end

  private

  def results(response)
    JSON.parse(response.body)['data']
  end

  def search_with_page_parameters
    {
      data: {
        type: 'searches',
        attributes: {
          query: {
            page: {
              number: 1,
              size: 1
            },
            number: 1,
            size: 1
          },
          saved: true
        }
      }
    }
  end

  def empty_saved_search
    { data: { type: 'searches', attributes: { query: {}, saved: true } } }
  end

  def empty_unsaved_search
    { data: { type: 'searches', attributes: { query: {} } } }
  end
end
