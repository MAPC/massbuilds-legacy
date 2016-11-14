require 'test_helper'

class ApproveTest < ActiveSupport::TestCase

  def approve_service
    Services::Edit::Approve
  end

  def approval
    @_approval ||= approve_service.new(edit)
  end

  def edit
    @_edit ||= edits(:one)
  end

  def development
    approval.edit.development
  end

  test 'precondition: edit is valid' do
    assert edit.valid?
  end

  test 'raises with invalid edit' do
    assert_raises(StandardError) do
      approve_service.new(Edit.new)
    end
  end

  test '#edit' do
    assert_equal approval.edit.id, edits(:one).id
  end

  test '#development' do
    assert_equal approval.development.id, developments(:one).id
  end

  test '#callable?' do
    assert approval.callable?
  end

  test 'not #callable?' do
    edit.applied = true
    refute approval.callable?
  end

  test '#call approves the edit' do
    approval.call
    assert_equal 'approved', edit.state
    assert edit.approved?
    assert edit.moderated_at
  end

  test '#call applies the changes' do
    approval.call
    assert edit.applied?
    assert edit.applied_at
  end

end
