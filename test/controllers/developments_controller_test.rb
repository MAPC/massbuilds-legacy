require 'test_helper'

class DevelopmentsControllerTest < ActionController::TestCase

  def development
    @_development ||= developments(:one)
  end

  test 'should get index' do
    skip 'Replaced by Ember'
    get :index
    # assert assigns(:developments).count > 1
    assert_response :success
  end

  test 'should get index, searching' do
    skip 'replaced by Ember'
    get :index, q: { commsf: '[11,13]' }
    assert_equal 1, assigns(:developments).count
    assert_response :success
  end

  test 'should get show' do
    get :show, id: development.id
    assert_response :success
  end

  test 'should get edit' do
    skip 'replaced by Ember'
    sign_in users(:normal)
    get :edit, id: development.id
    assert_response :success
  end

  test 'should patch update' do
    skip 'replaced by Ember'
    sign_in users(:normal)
    data = { name: "lol", rdv: true }
    assert_difference 'Edit.count + FieldEdit.count', +3 do
      patch :update, id: development.id, development: data
    end
    assert_response :redirect
  end

end
