require 'test_helper'

class API::V1::OrganizationsControllerTest < ActionController::TestCase

  def organization
    @_organization ||= organizations(:mapc)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: organization.id
    assert_response :success
  end

  test 'should not create, update, or destroy' do
    %i( create update destroy ).each do |action|
      assert_raises(StandardError) { post action }
    end
  end

  private

  def results(response)
    JSON.parse(response.body)['data']
  end

end
