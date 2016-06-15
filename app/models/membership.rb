class Membership < ActiveRecord::Base
  include Authority::Abilities
  extend Enumerize

  belongs_to :user
  belongs_to :organization
  alias_attribute :member, :user

  validates :user, presence: true
  validates :organization, presence: true, uniqueness: {
    scope: [:user_id],
    conditions: -> { where.not(state: :inactive) },
    message: 'You have already requested to join that organization.'
  }

  enumerize :state, in: [:pending, :invited, :active, :inactive, :declined],
    default: :pending, predicates: true

  enumerize :role, in: [:normal, :admin], default: :normal, predicates: true

  def self.active
    where state: 'active'
  end

  def self.pending
    where state: 'pending'
  end

  def self.inactive
    where.not state: 'inactive'
  end

  def self.admin
    where state: :active, role: :admin
  end

  def invited
    self.state = :invited
    self
  end

  def declined
    self.state = :declined
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
end
