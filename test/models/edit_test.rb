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

  test "defaults to status 'pending'" do
    assert_equal 'pending', Edit.new.state
  end

  test "requires a development" do
    edit.development = nil
    assert_not edit.valid?
  end

  test "requires an editor (user)" do
    edit.editor = nil
    assert_not edit.valid?
  end

  test "requires a state" do
    edit.state = nil
    assert_not edit.valid?
    edit.state = :blerg
    assert_not edit.valid?
  end

  test "cannot apply without a moderator/user" do
    skip "No roles implemented yet."
    edit.moderator = nil
    assert_raises(StandardError) { edit.apply! }
    assert_equal 'pending', edit.state
  end

  test "a normal user cannot apply" do
    skip "No roles implemented yet."
    edit.moderator = users :normal
    assert_raises(StandardError) { edit.apply! }
    assert_equal 'pending', edit.state
  end

  test "a moderator can apply" do
    skip "No roles implemented yet."
    edit.moderator = users :moderator
    assert_raises(StandardError) { edit.apply! }
    assert_equal 'applied', edit.state
  end

  # TODO Some of these might belong in Development
  # or there's service objects like Edit::Approval, Edit::Denial
  test "applying an edit alters the development history" do
    skip "Not clear on the architecture."
    # assert applying an edit changes history count by one
    assert_difference 'development.history.count', +1 do
      edit.apply!
    end
    # and that the first in the history is the last-applied edit
    assert_equal edit, development.history.first
    assert_equal :applied, edit.state
  end

  test "applying an edit without saving doesn't alter the history" do
    skip "Do we really need this special case?"
    # TODO some and then
    assert_equal 'applied_unsaved', edit.state
    assert_equal 'pending', edit.state
  end

  test "conflicts prevent writing" do
    conflicting_edit = edits :conflict
    assert conflicting_edit.conflict?
    # Changed from raising an error to simply returning false.
    # assert_raises(StandardError) { conflicting_edit.apply! }
    assert_not conflicting_edit.apply!
    assert_equal 'pending', conflicting_edit.state
  end

  test "ignore conflict and apply edit" do
    conflicting_edit = edits :conflict
    conflicting_edit.apply!
    assert conflicting_edit.apply!(ignore_conflict: true)
    assert_equal 'applied', conflicting_edit.state
  end

  # Belongs in Development
  test "revert to previous version" do
    skip
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