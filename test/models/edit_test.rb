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

  test "edited #fields" do
    assert_respond_to edit, :fields
  end

  test "requires a state" do
    edit.state = nil
    assert_not edit.valid?
    edit.state = :blerg
    assert_not edit.valid?
  end

  test "state predicates" do
    [:pending?, :applied?].each {|method|
      assert_respond_to edit, method
    }
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
    refute conflicting_edit.apply!
    conflicting_edit.ignore_conflicts = true
    assert conflicting_edit.apply!
    assert_equal 'applied', conflicting_edit.state
  end

  test "#conflict" do
    assert_empty edit.conflict
    edit.development.commsf = 13
    refute_empty edit.conflict
  end

  test "#conflict?" do
    refute edit.conflict?
    edit.development.commsf = 13
    assert edit.conflict?
  end

  test "#applyable" do
    assert edit.applyable?, [edit.inspect, edit.conflict?]
  end

  test "#not_applyable" do
    edit.state = :applied
    assert edit.not_applyable?
  end

  test "approved" do
    assert_respond_to edit, :approved
    edit.approved
    assert_equal 'applied', edit.state
    assert edit.moderated_at
  end

  test "declined" do
    assert_respond_to edit, :declined
    refute edit.moderated_at
    edit.declined
    assert_equal 'declined', edit.state
    assert_equal 'declined', edit.reload.state
    assert edit.moderated_at
  end

  # test "approval without save" do
  #   skip """
  #     The approval process and interface for edits is a little
  #     messy, still. Could use some refactoring work.
  #   """
  #   edit.approved(save: false)
  #   assert_equal 'approved', edit.state
  #   assert_equal 'approved', edit.reload.state
  # end

  # test "cannot apply without a moderator/user" do
  #   skip "No roles implemented yet."
  #   edit.moderator = nil
  #   assert_raises(StandardError) { edit.apply! }
  #   assert_equal 'pending', edit.state
  # end

  # test "a normal user cannot apply" do
  #   skip "No roles implemented yet."
  #   edit.moderator = users :normal
  #   assert_raises(StandardError) { edit.apply! }
  #   assert_equal 'pending', edit.state
  # end

  # test "a moderator can apply" do
  #   skip "No roles implemented yet."
  #   edit.moderator = users :moderator
  #   assert_raises(StandardError) { edit.apply! }
  #   assert_equal 'applied', edit.state
  # end

end
