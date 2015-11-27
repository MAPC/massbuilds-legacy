require 'test_helper'

class EditTest < ActiveSupport::TestCase
  def edit
    @edit ||= edits :one
  end

  def development
    @development ||= developments :one
  end
  alias_method :project, :development

  test "valid" do
    assert edit.valid?
  end

  test "after save, status 'pending'" do
    edit.save
    assert_equal :pending, edit.state
  end

  test "requires a development" do
    edit.development = nil
    assert_not edit.valid?
  end

  test "requires an editor (user)" do
    edit.editor = nil
    assert_not edit.valid?
  end

  test "to apply, requires a moderator" do
    edit.moderator = nil
    assert_raises StandardError, { edit.apply! }
    assert_equal :pending, edit.state
  end

  test "to apply, requires a valid, privileged moderator" do
    edit.moderator = users :normal
    assert_raises StandardError, { edit.apply! }
    assert_equal :pending, edit.state
  end

  # TODO Some of these might belong in Development
  # or there's service objects like Edit::Approval, Edit::Denial
  test "applying an edit alters the development history" do
    # assert applying an edit changes history count by one
    assert_changed { edit.apply! }, development.history.count
    # and that the first in the history is the last-applied edit
    assert_equal edit, development.history.first
    assert_equal :applied, edit.state
  end

  test "applying an edit without saving doesn't alter the history" do
    # TODO some and then
    assert_equal :applied_unsaved, edit.state
    assert_equal :pending, edit.state
  end

  test "conflicts prevent writing" do
    conflicting_edit = edits :conflict
    conflicting_edit.apply!
    edit.conflict?
    assert_raises StandardError, { edit.apply! }
    assert_equal :pending, edit.state
  end

  test "ignore conflict and apply edit" do
    conflicting_edit = edits :conflict
    conflicting_edit.apply!
    assert_nothing_raised {
      edit.apply!(ignore_conflict: true)
    }
    assert_equal :applied, edit.state
  end

  # Belongs in Development
  test "revert to previous version" do
    edit = edits :da39a3
    development.revert_to edit.ref
    development.history.first = edit
    # how is the forward history available?
    # This is like, branching. Ew.
    # Maybe we don't go back. Maybe there's only forward.
    # Maybe we use paper_trail. Maybe maybe maybe
  end

  test "revert to previous version with conflicts" do
    # unclear
  end
end