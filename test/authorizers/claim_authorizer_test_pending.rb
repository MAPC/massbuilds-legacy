require 'test_helper'

class ClaimAuthorizerTest < ActiveSupport::TestCase

  # Known Users
  #   Can claim a project, which kicks off verification
  #
  # Moderators on a development
  #   Can approve or reject a claim

  def authorizer
    ClaimAuthorizer
  end

  def user
    @_user ||= users(:normal)
  end

  def claimant
    @_claimant ||= users(:peter_pan)
  end

  def claim
    @_claim || Claim.new(
      development: developments(:one),
      claimant: claimant,
      role: :developer
    )
  end

  test 'known user cannot claim a development' do
    assert authorizer.creatable_by?(user, for: Organization.new)
  end

  test 'organization member can claim a development' do
    assert authorizer.creatable_by?(user, for: Organization.new)
  end

end
