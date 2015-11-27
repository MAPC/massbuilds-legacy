require 'test_helper'

class ClaimTest < ActiveSupport::TestCase

  def user
    @user ||= users :one
  end
  alias_method :claimant, :user

  def project
    @project ||= projects :one
  end

  # TODO: Clearly not just a unit test.
  def moderator
    @moderator ||= users :moderator
  end

  def admin
    @admin ||= users :admin
  end

  def claim
    @claim ||= Claim.new(project:  project, claimant: claimant)
  end
  alias_method :c, :claim

  test "valid" do
    assert claim.valid?
  end

  test "requires a claimant (user)" do
    claim.claimant = nil
    assert_not claim.valid?
  end

  test "requires a project" do
    claim.project = nil
    assert_not claim.valid?
  end

  test "approval" do
    claim.approve!
    assert_equal :approved, claim.state
  end

  test "approval can take a reason string" do
    claim.approve! "Message"
    assert_equal :approved, claim.state
    assert_equal claim.reason, "Message"
  end

  test "approval can take a reason hash" do
    claim.approve! reason: "Message"
    assert_equal :approved, claim.state
    assert_equal claim.reason, "Message"
  end

  test "denial with a string message" do
    message = "Reason for deny."
    claim.deny! message
    assert_equal :denied, claim.state
    assert_equal message, claim.reason
  end

  test "denial with a hash message" do
    message = "Reason for deny."
    claim.deny! reason: message
    assert_equal :denied, claim.state
    assert_equal message, claim.reason
  end

  test "denial requires a reason" do
    assert_raises StandardError, { claim.deny! }
  end

  test "requires a moderator" do
    assert_raises StandardError, { claim.approve! moderator: nil }
  end

  # Needing so many collaboratiors suggests the need for
  # service objects like Claim::Approval and Claim::Denial
  test "user cannot moderate their own claim unless admin" do
    assert_raises StandardError {
      claim.approve! moderator: claimant
    }
    claimant.update_attribute(:moderator, true)
    assert_raises StandardError {
      claim.approve! moderator: claimant
    }
    assert_nothing_raised {
      claim.approve! moderator: admin
    }
  end
end
