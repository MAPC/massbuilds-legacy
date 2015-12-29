class Edit < ActiveRecord::Base
  extend Enumerize

  has_many :fields, class_name: :EditField, dependent: :nullify

  belongs_to :editor,    class_name: :User
  belongs_to :moderator, class_name: :User
  belongs_to :development

  validates :development, presence: true
  validates :editor, presence: true
  validates :state,  presence: true

  enumerize :state, in: [:pending, :applied, :approved, :declined],
    default: :pending, predicates: true

  def approved(options={})
    self.moderated_at = Time.now
    self.state = :approved
    apply!(options)
  end

  def declined(options={})
    self.moderated_at = Time.now
    self.state = :declined
    self.save! if should_save?(options)
  end

  # Alter self.development with contents, and optionally save.
  def apply!(options={})
    return false unless applyable?
    apply(options)
    if should_save?(options)
      transaction do
        self.save!
        development.save!
      end
    end
  end

  def apply(options={})
    applied if development.fields.merge!(assignable_attributes)
  end

  def applied
    self.applied_at = Time.now
    self.state = :applied
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

  def not_applyable?
    !applyable?
  end

  def conflicts
    fields.map(&:conflict).compact
  end
  alias_method :conflict, :conflicts

  def conflicts?
    conflicts.any?
  end
  alias_method :conflict?, :conflicts?

  private

    # If there's a conflict, and we aren't explicitly ignoring it.
    def unignored_conflict?
      conflict? && !ignore_conflicts?
    end

    # Returns a hash that can be used in assign_attributes
    # or update_attributes.
    def assignable_attributes
      names, to_values = fields.pluck(:name), fields.map(&:to)
      Hash[names.zip(to_values)]
    end

    def should_save?(options={})
      options.fetch(:save, true)
    end
end
