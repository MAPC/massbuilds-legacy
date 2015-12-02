require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

  def membership
    @membership = memberships :one
  end
  alias_method :m, :membership

  test "valid" do
    assert m.valid?
  end

  test "requires a member" do
    m.member = nil
    assert_not m.valid?
  end

  test "requires an organization" do
    m.organization = nil
    assert_not m.valid?
  end

  test "defaults to pending" do
    assert_equal 'pending', Membership.new.state
  end

  test "state predicates" do
    [:pending?, :invited?, :active?, :inactive?].each {|method|
      assert_respond_to membership, method
    }
  end

  test "#invited" do
    assert_equal 'invited', m.invited.state
  end

  test "#activated" do
    assert_equal 'active', m.activated.state
  end

  test "#deactivated" do
    assert_equal 'inactive', m.deactivated.state
  end
end
