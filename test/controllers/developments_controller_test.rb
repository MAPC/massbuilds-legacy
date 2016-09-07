require 'test_helper'

class DevelopmentsControllerTest < ActionController::TestCase

  def development
    @_development ||= developments(:one)
  end

  # test 'should get index' do
  #   skip 'Replaced by Ember'
  #   get :index
  #   assert assigns(:developments).count > 1
  #   assert_response :success
  # end

  # test 'should get index, searching' do
  #   skip 'replaced by Ember'
  #   get :index, q: { commsf: '[11,13]' }
  #   assert_equal 1, assigns(:developments).count
  #   assert_response :success
  # end

  test 'should get show' do
    get :show, id: development.id
    assert_response :success
  end

  test 'should get show and have a flash' do
    get :show, id: development.id, proposal: 'success'
    assert_response :success
    assert_equal 'developments/proposed_success', flash[:partial][:path]
  end

  test 'should get show and not have a flash' do
    get :show, id: development.id, proposal: 'meh'
    assert_response :success
    refute_equal 'developments/proposed_success', flash[:partial].fetch(:path, nil)
  end

  # test 'should get edit' do
  #   skip 'replaced by Ember, takes too long to run maybe because waiting for JS'
    # sign_in users(:normal)
    # get :edit, id: development.id
    # assert_response :success
  # end

  # test 'should patch update' do
  #   skip 'replaced by Ember'
  #   sign_in users(:normal)
  #   data = { name: "lol", rdv: true }
  #   assert_difference 'Edit.count + FieldEdit.count', +3 do
  #     patch :update, id: development.id, development: data
  #   end
  #   assert_response :redirect
  # end

  test 'should convert the right floor areas - not divided by 100' do
    skip 'Not yet implemented'
  end

end
