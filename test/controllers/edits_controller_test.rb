require 'test_helper'

class EditsControllerTest < ActionController::TestCase

  def development
    @_development ||= developments(:one)
  end

  def edit
    @_edit ||= development.edits.last
  end

  test "should get pending" do
    get :pending, development_id: development.id
    assert_response :success
  end

  test "should approve" do
    refute edit.conflict?, edit.conflict.inspect
    assert_difference 'development.history.count', +1 do
      post :approve, development_id: development.id, id: edit.id
    end
    assert_response :redirect
  end

  test "should decline" do
    assert_difference 'development.pending_edits.count', -1 do
      post :decline, development_id: development.id, id: edit.id
    end
    assert_response :redirect
  end

end
