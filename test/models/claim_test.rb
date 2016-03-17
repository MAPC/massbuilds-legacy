require 'test_helper'

class ClaimTest < ActiveSupport::TestCase

  def user
    @user ||= users :normal
  end
  alias_method :claimant, :user

  def development
    @development ||= developments :one
  end

  def moderator
    @moderator ||= users :moderator
  end

  def claim
    @claim ||= Claim.new(
      development: development,
      claimant: claimant,
      role: :developer
    )
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

  test 'valid' do
    assert claim.valid?
  end

  test 'requires a claimant (user)' do
    claim.claimant = nil
    assert_not claim.valid?
  end

  test 'requires a development' do
    claim.development = nil
    assert_not claim.valid?
  end

  test 'default state is pending' do
    assert_equal 'pending', Claim.new.state
  end

  test 'state predicates' do
    [:pending?, :approved?, :denied?].each { |method|
      assert_respond_to claim, method
    }
  end

  test 'approval' do
    moderated_claim.approve!
    assert_equal 'approved', moderated_claim.state
    assert_equal nil, moderated_claim.reason
  end

  test 'approval can take a reason hash' do
    mc.approve! reason: "Message"
    assert_equal 'approved', mc.state
    assert_equal mc.reason, "Message"
  end

  test 'denial with a hash message' do
    message = "Reason for deny."
    mc.deny! reason: message
    assert_equal 'denied', mc.state
    assert_equal message, mc.reason
  end

  test 'denial requires a reason' do
    assert_raises(StandardError) { mc.deny! }
  end

  test 'approval requires a moderator' do
    assert_raises(ArgumentError) { claim.approve!(moderator: nil) }
    assert_raises(ArgumentError) { claim.approve!(blerg: :blarg) }
  end

  test 'requires a role' do
    claim.role = ' '
    assert_not claim.valid?
    claim.role = nil
    assert_not claim.valid?
  end

  test 'requires a valid role' do
    [:developer, :owner].each do |role|
      claim.role = role
      assert claim.valid?
    end
    [:blerg, :blarg].each do |role|
      claim.role = role
      assert_not claim.valid?
    end
  end

  # Needing so many collaboratiors suggests the need for
  # service objects like Claim::Approval and Claim::Denial
  test 'user cannot moderate their own claim unless admin' do
    skip '''
      Expecting this to fail because we have not yet implemented
      roles like :admin that would help this pass.
    '''
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
