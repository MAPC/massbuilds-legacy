require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

  def membership
    @membership = memberships :one
  end
  alias_method :m, :membership

  test 'valid' do
    assert m.valid?
  end

  test 'requires a member' do
    m.member = nil
    assert_not m.valid?
  end

  test 'requires an organization' do
    m.organization = nil
    assert_not m.valid?
  end

  test 'defaults to pending' do
    assert_equal 'pending', Membership.new.state
  end

  test 'state predicates' do
    [:pending?, :invited?, :active?, :inactive?, :declined?].each { |method|
      assert_respond_to membership, method
    }
  end

  test '#invited' do
    assert_equal 'invited', m.invited.state
  end

  test '#activated' do
    assert_equal 'active', m.activated.state
  end

  test '#deactivated' do
    assert_equal 'inactive', m.deactivated.state
  end

  test '#declined' do
    assert_equal 'declined', m.declined.state
  end

  # I think this belongs in a controller test
  test 'member can leave an organization' do
    skip 'For now'
    user = m.user
    org  = m.organization

    user.memberships.each(&:activated)
    assert_not_empty org.active_members

    user.memberships.each(&:deactivated)
    assert_empty org.active_members
  end

  # test 'only administrators can promote members' do
  #   skip 'Roles not yet implemented'
  # end

  # test 'administrators are notified when someone leaves the org' do
  #   skip 'Roles and notifications not yet implemented'
  # end

  # test 'administrators are notified when someone wants in' do
  #   skip 'email, notification / inbox'
  # end
end
