require 'test_helper'

class EditApprovalTest < ActiveSupport::TestCase
  def approval
    @_approval ||= EditApproval.new(edits(:one))
  end

  def edit
    approval.edit
  end

  def development
    approval.edit.development
  end

  test 'precondition: edit is valid' do
    assert edit.valid?
  end

  test 'raises with invalid edit' do
    assert_raises(StandardError) do
      EditApproval.new(Edit.new)
    end
  end

  test '#edit' do
    assert_equal approval.edit.id, edits(:one).id
  end

  test '#development' do
    assert_equal approval.development.id, developments(:one).id
  end

  test '#performable?' do
    assert approval.performable?, [edit.inspect]
  end

  test 'not #performable?' do
    edit.applied = true
    refute approval.performable?, [edit.inspect, edit.conflict?]
  end

  test '#perform! approves the edit' do
    approval.perform!
    assert_equal 'approved', edit.state
    assert edit.approved?
    assert edit.moderated_at
  end

  test '#perform! applies the changes' do
    approval.perform!
    assert edit.applied?
    assert edit.applied_at
  end

end
