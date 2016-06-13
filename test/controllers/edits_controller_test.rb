require 'test_helper'

class EditsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def development
    @_development ||= developments(:one)
  end

  def edit
    @_edit ||= development.edits.last
  end

  def user
    @_user ||= users(:normal)
    @_user.password = 'password'
    @_user
  end

  def setup
    sign_in user
  end

  test 'precondition: valid edit' do
    assert development.valid?, development.errors.full_messages
    assert edit.valid?, edit.errors.full_messages
    assert user.moderator_for? development
  end

  test 'should get pending' do
    skip 'should be passing!'
    sign_in user
    get :pending, development_id: development.id
    assert_response :success
  end

  test 'should approve' do
    skip 'should be passing!'
    refute edit.conflict?, edit.conflict.inspect
    assert_difference 'Edit.applied.count', +1 do
      post :approve, development_id: development.id, id: edit.id
    end
    assert_response :redirect
  end

  test 'should decline' do
    skip 'should be passing!'
    assert_difference 'Edit.pending.count', -1 do
      post :decline, development_id: development.id, id: edit.id
    end
    assert_response :redirect
  end

end
