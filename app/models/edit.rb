class Edit < ActiveRecord::Base
  extend Enumerize

  has_many :fields, class_name: :FieldEdit, dependent: :destroy

  belongs_to :editor,    class_name: :User
  belongs_to :moderator, class_name: :User
  belongs_to :development

  validates :development, presence: true
  validates :editor, presence: true
  validates :state,  presence: true
  validates :moderated_at, presence: true, if: -> { approved? || declined? }

  enumerize :state, in: [:pending, :approved, :declined],
    default: :pending, predicates: true

  # TODO: Do these belong here, if the service is handling
  # the alteration of state?
  def approved
    assign_attributes(moderated_at: Time.now, state: :approved)
  end

  def declined
    assign_attributes(moderated_at: Time.now, state: :declined)
  end

  def applied
    assign_attributes(applied_at: Time.now, applied: true)
  end

  # The edit can be applied if:
  # - it's not already applied AND
  # - there's no conflict OR there is a conflict but it is ignored.
  def applyable?
    if applied? || unignored_conflict?
      false
    else
      true
    end
  end

  def moderated?
    moderated_at.presence || approved? || declined?
  end

  def moderatable?
    !moderated?
  end

  def conflicts
    fields.map(&:conflict).compact
  end

  def conflicts?
    conflicts.any?
  end

  alias_method :conflict,  :conflicts
  alias_method :conflict?, :conflicts?

  private

  # Returns true if there is a conflict,
  # and we aren't explicitly ignoring it.
  def unignored_conflict?
    conflict? && !ignore_conflicts?
  end

end
