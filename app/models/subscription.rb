class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscribable, polymorphic: true

  validates :user, presence: true,
    uniqueness: { scope: [:subscribable_id, :subscribable_type] }
  validates :subscribable, presence: true
  validate :valid_subscribable

  def needs_update?
    return false unless subscribable
    subscribable.updated_since? user.last_checked_subscriptions
  end

  private

  def valid_subscribable
    sub = subscribable
    unless sub.is_a?(Development) || sub.respond_to?(:developments)
      errors.add :subscribable,
        'must be a Development or respond to #developments'
    end
  end
end
