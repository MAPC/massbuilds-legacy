require 'test_helper'

class EditsControllerTest < ActionController::TestCase

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
    sign_in users(:normal)
  end

  test 'precondition: valid edit' do
    assert development.valid?
    assert edit.valid?
    assert user.moderator_for?(development)
  end

  test 'should get pending' do
    sign_in users(:normal)
    get :pending, development_id: development.id
    assert_response :success
  end

  test 'should approve' do
    assert_difference 'Edit.applied.count', +1 do
      post :approve, development_id: development.id, id: edit.id
    end
    assert_response :redirect
  end

  test 'should decline' do
    assert_difference 'Edit.pending.count', -1 do
      post :decline, development_id: development.id, id: edit.id
    end
    assert_response :redirect
  end

end
