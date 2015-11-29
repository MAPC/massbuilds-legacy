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
    flag.reason = "hello is it me you're " # 22
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

  test "changes moderator's inbox count" do
    skip "This is a tangential collaborator and does not belong here."
    assert_difference 'flag.development.moderator.first.inbox.count', +1 do
      flag.save
    end
  end
end
