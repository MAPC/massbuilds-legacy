class Claim < ActiveRecord::Base
  belongs_to :claimant,  model_name: :User
  belongs_to :development
  belongs_to :moderator, model_name: :User
  # belongs_to :role
  # => I am the [owner, developer] of this project.

  def approve!(options={})
    self.moderator = options.fetch(:moderator) {
      raise ArgumentError, "approving a claim requires a :moderator option"
    }
    self.reason = options.fetch(:reason) { nil }
    assert_valid_moderator
    self.state = :approved
    attributes = Hash[role.to_sym, user] # moderator: #<User: claimant>
    project.assign_attributes(attributes)
    self.save
  end

  def deny!(options={})
    self.moderator = options.fetch(:moderator) {
      raise ArgumentError, "approving a claim requires a :moderator option"
    }
    self.reason = options.fetch(:reason) {
      raise ArgumentError, "denying a claim requires a :reason option"
    }
    assert_valid_moderator
    assert_valid_message
    self.state = :denied
    self.save
  end

  alias_method :approve!, :accept!
  alias_method :deny!, :reject!
  alias_method :deny!, :decline!

  private

    def assert_valid_moderator
      raise unless moderator.is_moderator?(project)
    end
end
