require 'test_helper'

class MembershipAuthorizerTest < ActiveSupport::TestCase

  def user
    @_user ||= users(:tim)
  end

  def admin
    @_admin ||= users(:normal)
  end

  def organization
    @_org ||= organizations(:mapc)
  end

  def membership
    @_mem ||= memberships(:one) # between Normal and MAPC
  end

  def authorizer
    MembershipAuthorizer
  end

  test 'known user can join an organization' do
    assert authorizer.creatable_by?(user, for: Organization.new)
  end

  test 'known user cannot join an organization twice' do
    refute authorizer.creatable_by?(admin, for: organization)
  end

  test 'organization admin can approve pending membership' do
    membership.activated
    assert membership.authorizer.updatable_by?(admin)
    refute membership.authorizer.updatable_by?(user)
  end

  test 'organization admin can decline pending membership' do
    skip "We have a deactivated, but not a declined."
  end

  test 'organization admin can deactivate active membership' do
    membership.deactivated
    assert membership.authorizer.updatable_by?(admin)
    refute membership.authorizer.updatable_by?(user)
  end

  test 'cannot change other attributes of memberships' do
    # Create unauthorized changes
    membership.user_id = 100
    membership.created_at = Time.at(100)
    # Should prevent these changes from happening
    refute membership.authorizer.updatable_by?(admin)
  end

  test 'cannot change membership back to :invited' do
    skip 'Low priority'
  end

  test 'organization admin can promote members' do
    skip "We don't yet have organization membership roles."
  end

end
