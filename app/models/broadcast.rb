class Broadcast < ActiveRecord::Base
  extend Enumerize
  # Everyone gets the same notification,
  # or same general notification with custom variables.
  belongs_to :creator, class_name: :User

  validates :subject, presence: true
  validates :body, presence: true

  enumerize :state, in: [:draft, :scheduled, :delivered],
    default: :draft, predicates: true

  # This is 'telling'.
  def schedule!
    raise StandardError, 'Not schedulable.' unless schedulable?
    # TODO: Scheduling work
    scheduled
  end

  # This is 'notifying'.
  def scheduled
    self.state = :scheduled
  end

  def deliver!
    raise StandardError, 'Not deliverable.' unless deliverable?
    # TODO: Delivery work
    # This #delivered call may exist in the background job,
    # but we're writing it here to notify that the 'work', presently
    # nothing, is done.
    delivered
  end

  def delivered
    self.state = :delivered
  end

  def schedulable?
    scope.present? && scheduled_for.present? &&
      scope_returns_at_least_one_record
  end

  def deliverable?
    scope.present? && scope_returns_at_least_one_record
  end

  private

  def scope_returns_at_least_one_record
    User.where(scope).any?
  end

end
