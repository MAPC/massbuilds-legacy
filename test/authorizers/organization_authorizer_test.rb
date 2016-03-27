require 'test_helper'

class OrganizationAuthorizerTest < ActiveSupport::TestCase

  def authorizer
    OrganizationAuthorizer
  end

  def user
    @_user ||= users(:normal)
  end

  # def admin
  #   @_admin ||= users(:org_admin)
  # end

  def organization
    @_org ||= Organization.new
  end

  test 'an anonymous user cannot create an organization' do
    user.stub :known?, false do
      refute authorizer.creatable_by?(user)
    end
  end

  test 'any known user can create an organization' do
    assert authorizer.creatable_by?(user)
  end

  test 'organization admin can edit organization' do
    skip 'No org admins yet'
    assert authorizer.updatable_by?(admin)
  end

  # Can ask to join organizations
  #   Can leave organizations (deactivate memberships)
  #   Can approve or decline edits on which their organization is a development team member

  # Organization Admins
  #   Can edit organization settings


end
