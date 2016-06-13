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
    refute flag.valid?
  end

  test 'must give a reason of certain length' do
    flag.reason = nil
    refute flag.valid?
    flag.reason = " "
    refute flag.valid?
    flag.reason = "hello is it me you're " # 22
    refute flag.valid?
    flag.reason = 'a' * 500
    refute flag.valid?
  end

  test 'requires a known (not anonymous or null) flagger' do
    u = User.null
    flag.flagger = u
    refute flag.valid?
  end

  test 'requires a development' do
    flag.development = nil
    refute flag.valid?
  end

  test "changes moderator's inbox count" do
    skip 'This is a tangential collaborator and does not belong here.'
    assert_difference 'flag.development.moderator.first.inbox.count', +1 do
      flag.save
    end
  end

  test 'default state is pending' do
    assert_equal 'pending', Flag.new.state
  end

  test 'state predicates' do
    [:pending?, :open?, :resolved?].each { |method|
      assert_respond_to flag, method
    }
  end

  test '#submitted / flagged' do
    flag.submitted
    assert_equal 'open', flag.state
  end

  test '#resolved' do
    flag.resolver = users(:normal)
    assert_nothing_raised { flag.resolved }
    assert_equal 'resolved', flag.state
  end

  test '#resolved requires a resolver' do
    flag.resolver = nil
    assert_raises(StandardError) { flag.resolved }
  end
end
