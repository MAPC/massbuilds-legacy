require 'test_helper'

class FlagTest < ActiveSupport::TestCase
  def flag
    @flag ||= flags :one
  end

  test 'valid' do
    assert flag.valid?
  end

  test 'requires a flagger' do
    flag.flagger = nil
    assert_not flag.valid?
  end

  # What is the comment requirement for StackOverflow?
  test 'if reason given, must be a certain length' do
    flag.reason = nil
    assert flag.valid?
    flag.reason = " "
    assert flag.valid?
    flag.reason = "hello is it me you're "
    assert_not flag.valid?
    flag.reason = 'a' * 500
    assert_not flag.valid?
  end

  test 'requires a known (not anonymous or null) flagger' do
    u = User.null
    flag.flagger = u
    assert_not flag.valid?
  end

  test 'requires a development' do
    flag.development = nil
    assert_not flag.valid?
  end

  # TODO: Syntax
  test 'changes development flag count' do
    assert_changed {
      flag.save
    }, flag.development.flags.count, by(1)
  end

  # This is a tangential collaborator.
  # TODO: Syntax
  test "changes moderator's inbox count" do
    assert_changed {
      flag.save
    }, flag.development.moderator.inbox.count, by(1)
  end
end
