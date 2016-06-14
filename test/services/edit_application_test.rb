require 'test_helper'

class EditApplicationTest < ActiveSupport::TestCase
  def application
    @_application ||= EditApplication.new(edits(:one))
  end

  def edit
    application.edit
  end

  def development
    application.development
  end

  test '#edit' do
    assert_equal application.edit.id, edits(:one).id
  end

  test '#performable?' do
    assert application.performable?, "Is edit applyable? #{application.edit.applyable?}"
  end

  test 'not #performable?' do
    edit.applied = true
    refute application.performable?
  end

  test 'perform! sets :applied' do
    application.perform!
    assert edit.applied?, edit.state.inspect
    assert edit.applied_at
  end

  test 'perform! applies edits' do
    assert_equal 0, development.commsf
    application.perform!
    assert_equal 1000, development.commsf
  end

  test 'perform! applies and saves edits' do
    assert_equal 0, development.commsf
    application.perform!
    assert_equal 1000, development.reload.commsf
  end

  test 'perform! when conflict returns false' do
    conflict = EditApplication.new(edits(:conflict))
    refute conflict.perform! # Should not change anything
    assert_equal 'pending', conflict.edit.state
    assert_equal 0, conflict.development.commsf
  end

  test 'ignore conflict and apply edit' do
    conflict = EditApplication.new(edits(:conflict))
    refute conflict.perform!
    conflict.edit.ignore_conflicts = true
    conflict.perform!
    assert conflict.edit.applied?
    assert_equal 100, conflict.development.commsf
  end

end
