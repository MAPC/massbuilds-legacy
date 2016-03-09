class Verification < ActiveRecord::Base
  extend Enumerize
  # TODO: Should be polymorph-ish. Basically, while it should belong
  # to user (because a person must request it), they can also
  # request it on behalf of an organization.

  belongs_to :user
  belongs_to :verifier, class_name: :User

  validates :user, presence: true
  validates :reason, allow_blank: true, length: { minimum: 30, maximum: 1000 }
  validates :reason, presence: true, length: { minimum: 30, maximum: 1000 },
    if: :valid_verifier?

  enumerize :state, in: [:pending, :requested, :verified, :rejected],
    default: :pending, predicates: true

  def verifiable?
    # TODO: [Code Smell] Multiple calls to valid_verifier?
    # are already getting confusing.
    valid? && eligible_user? && valid_verifier?
  end

  def requested
    self.state = :requested
  end

  def verified
    assert_verifiable
    self.state = :verified
  end

  def rejected
    assert_verifiable
    self.state = :rejected
  end

  def closed?
    verified? || rejected?
  end

  def open?
    !closed?
  end

  private

  def assert_verifiable
    if verifiable?
      true
    else
      raise StandardError, 'Must be verifiable to verify.'
    end
  end

  # TODO: [Code Smell] Should these be validations?
  def eligible_user?
    user.present? # TODO: user.verifiable?
  end

  def valid_verifier?
    verifier.present? # TODO: verifier.can_verify?(user)
  end

end
