class Membership < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :organization
  alias_attribute :member, :user

  validates :user, presence: true
  validates :organization, presence: true
  validates_uniqueness_of :organization_id, scope: [:user_id], conditions: -> { where.not(state: :inactive) }

  enumerize :state, in: [:pending, :invited, :active, :inactive],
    default: :pending, predicates: true

  def invited
    self.state = :invited
    self
  end

  def activated
    self.state = :active
    self
  end

  def deactivated
    self.state = :inactive
    self
  end

  def is_unique?

  end
end
