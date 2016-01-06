require 'test_helper'

class DevelopmentsControllerTest < ActionController::TestCase

  def development
    @_development ||= developments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: development.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: development.id
    assert_response :success
  end

  test "should patch update" do
    patch :update, id: development.id
    assert_response :created
  end

end
