require 'test_helper'

class ClaimTest < ActiveSupport::TestCase

  def user
    @user ||= users :normal
  end
  alias_method :claimant, :user

  def development
    @development ||= developments :one
  end

  # TODO: Clearly this is not just a unit test.
  def moderator
    @moderator ||= users :moderator
  end

  def claim
    @claim ||= Claim.new(development: development, claimant: claimant)
  end
  alias_method :c, :claim

  def moderated_claim
    @moderated_claim ||= Claim.new(
      development: development,
      claimant:    claimant,
      moderator:   moderator
    )
  end
  alias_method :mc, :moderated_claim

  test "valid" do
    assert claim.valid?
  end

  test "requires a claimant (user)" do
    claim.claimant = nil
    assert_not claim.valid?
  end

  test "requires a development" do
    claim.development = nil
    assert_not claim.valid?
  end

  test "approval" do
    moderated_claim.approve!
    assert_equal 'approved', moderated_claim.state
    assert_equal nil, moderated_claim.reason
  end

  test "approval can take a reason hash" do
    mc.approve! reason: "Message"
    assert_equal 'approved', mc.state
    assert_equal mc.reason, "Message"
  end

  test "denial with a hash message" do
    message = "Reason for deny."
    mc.deny! reason: message
    assert_equal 'denied', mc.state
    assert_equal message, mc.reason
  end

  test "denial requires a reason" do
    assert_raises(StandardError) { mc.deny! }
  end

  test "requires a moderator" do
    assert_raises(StandardError) { claim.approve!(moderator: nil) }
  end

  # Needing so many collaboratiors suggests the need for
  # service objects like Claim::Approval and Claim::Denial
  test "user cannot moderate their own claim unless admin" do
    skip """
      Expecting this to fail because we have not yet implemented
      roles like :admin that would help this pass.
    """
    assert_raises(StandardError) {
      claim.approve! moderator: claimant
    }
    claimant.update_attribute(:moderator, true)
    assert_raises(StandardError) {
      claim.approve! moderator: claimant
    }
    assert_nothing_raised {
      claim.approve! moderator: admin
    }
  end
end
