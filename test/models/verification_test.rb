require 'test_helper'

class VerificationTest < ActiveSupport::TestCase
  def verification
    @v ||= verifications :one
  end
  alias_method :v, :verification

  test 'valid' do
    assert verification.valid?, verification.errors.full_messages
  end

  test 'requires a user' do
    v.user = nil
    assert_not v.valid?
  end

  test 'requires a verifier to verify' do
    v.verifier = nil
    assert_not v.verifiable?
    assert_raises(StandardError) { v.verified }
  end

  test 'requires a reason to verify' do
    reasons = [
      nil,
      'This is reason enough, no?',
      'a' * 1001
    ]
    reasons.each do |reason|
      v.reason = reason
      assert_not v.verifiable?
      assert_raises(StandardError) { v.verified }
    end
  end

  test 'state predicates' do
    [:pending?, :requested?].each { |method|
      assert_respond_to v, method
    }
  end

  test '#new' do
    assert_equal 'pending', Verification.new.state
  end

  test '#requested' do
    v.requested
    assert_equal 'requested', v.state
  end

  test '#verified' do
    v.verified
    assert_equal 'verified', v.state
  end

  test '#rejected' do
    v.rejected
    assert_equal 'rejected', v.state
  end

  test '#open' do
    assert v.open?
  end

  test '#closed' do
    v.state = :verified
    assert v.closed?
    v.state = :rejected
    assert v.closed?
  end
end
