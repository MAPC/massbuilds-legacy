require 'test_helper'

class API::SearchesControllerTest < ActionController::TestCase
  def setup
    JSONAPI.configuration.raise_if_parameters_not_allowed = true
  end

  def set_content_type_header!
    @request.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
  end

  def search
    @_search ||= searches(:ranged)
  end

  test "index" do
    get :index
    assert_response :success
    %w( id query saved user ).each { |i| assert_includes response.body, i }
  end

  test "show" do
    get :show, id: search.id
    assert_response :success
  end

  test "create" do
    skip "\nAuthentication not working\n"
    sign_in users(:normal) # TODO Figure out authentication
    set_content_type_header!
    post :create,
         {
           data: {
             type: 'searches',
             attributes: { query: {} }
           }
         }
    assert_response :created, response.body
  end

end
