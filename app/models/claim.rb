class Claim < ActiveRecord::Base
  extend Enumerize

  belongs_to :claimant,  class_name: :User
  belongs_to :development
  belongs_to :moderator, class_name: :User

  validates :development, presence: true
  validates :claimant,    presence: true
  validates :role,        presence: true

  enumerize :state, in: [:pending, :approved, :denied],
    default: :pending, predicates: true

  enumerize :role, in: DevelopmentTeamMembership.role.options

  def approve!(options = {})
    save if approve(options)
  end

  def approve(options = {})
    self.reason = options.fetch(:reason) { nil }
    assert_valid_moderator(options)
    # TODO: Assign claimant as desired role on project.
    approved
  end

  def approved
    self.state = :approved
  end

  def deny!(options = {})
    save if deny(options)
  end

  def deny(options)
    assert_valid_moderator(options)
    assert_valid_reason(options)
    denied
  end

  def denied
    self.state = :denied
  end

  # alias_method :approve!, :accept!
  # alias_method :deny!, :reject!
  # alias_method :deny!, :decline!

  private

  def assert_valid_moderator(options)
    self.moderator ||= options.fetch(:moderator) do
      raise ArgumentError, 'approving a claim requires a :moderator option'
    end
    if self.moderator.nil?
      raise ArgumentError, ':moderator option must be a non-nil'
    end
  end

  def assert_valid_reason(options)
    self.reason ||= options.fetch(:reason) do
      raise ArgumentError, 'denying a claim requires a :reason option'
    end
  end
end
