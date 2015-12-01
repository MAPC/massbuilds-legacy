class Verification < ActiveRecord::Base
  belongs_to :user
  belongs_to :verifier, class_name: :User

  after_initialize :default_state

  validates :user, presence: true
  validates :reason, allow_blank: true, length: { minimum: 30, maximum: 1000 }
  validates :reason, presence: true, length: { minimum: 30, maximum: 1000 }, :if => :valid_verifier?

  def verifiable?
    # TODO [Code Smell] Multiple calls to valid_verifier?
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

  private

    def default_state
      self.state ||= :pending
    end

    def assert_verifiable
      if verifiable?
        true
      else
        raise StandardError, "Must be verifiable to verify."
      end
    end

    # TODO [Code Smell] Should these be validations?
    def eligible_user?
      user.present? # TODO: user.verifiable?
    end

    def valid_verifier?
      verifier.present? # TODO: verifier.can_verify?(user)
    end

end
