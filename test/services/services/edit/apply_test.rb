require 'test_helper'

class ApplyTest < ActiveSupport::TestCase

  def apply_service
    Services::Edit::Apply
  end

  def application
    @_application ||= apply_service.new(edit)
  end

  def edit
    @_edit ||= edits(:one)
  end

  def development
    application.development
  end

  test '#edit' do
    assert_equal application.edit.id, edits(:one).id
  end

  test '#callable?' do
    assert application.callable?, "Is edit applyable? #{application.edit.applyable?}"
  end

  test 'not #callable?' do
    edit.applied = true
    refute application.callable?
  end

  test 'sets state to :applied' do
    application.call
    assert edit.applied?, edit.state.inspect
    assert edit.applied_at
  end

  test 'applies edits' do
    assert_equal 0, development.commsf
    application.call
    assert_equal 1000, development.commsf
  end

  test 'applies and saves edits' do
    assert_equal 0, development.commsf
    application.call
    assert_equal 1000, development.reload.commsf
  end

  test 'when conflict returns false' do
    conflict = apply_service.new(edits(:conflict))
    refute conflict.call # Should not change anything
    assert_equal 'pending', conflict.edit.state
    assert_equal 0, conflict.development.commsf
  end

  test 'ignore conflict and apply edit' do
    conflict = apply_service.new(edits(:conflict))
    refute conflict.call
    conflict.edit.ignore_conflicts = true
    conflict.call
    assert conflict.edit.applied?
    assert_equal 100, conflict.development.commsf
  end

end
