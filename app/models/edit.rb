class Edit < ActiveRecord::Base
  extend Enumerize

  has_many :fields, class_name: :EditField

  belongs_to :editor,    class_name: :User
  belongs_to :moderator, class_name: :User
  belongs_to :development

  validates :development, presence: true
  validates :editor, presence: true
  validates :state,  presence: true, inclusion: { in: %W( pending applied ) }

  enumerize :state, in: [:pending, :applied], default: :pending, predicates: true

  default_scope { includes(:fields) }

  # Alter self.development with contents, and optionally save.
  def apply!(options={})
    return false if unignored_conflict?(options)
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

  # The edit can be applied if it's not applied and there's no conflict.
  def applyable?
    if applied? || conflict?
      false
    else
      true
    end
  rescue StandardError => e
    puts "APPLYABLE ERROR: #{e.inspect}"
    false
  end

  def not_applyable?
    !applyable?
  end

  # Edit's "from" values which are different from the development's
  # current values
  def conflict
    from_values.select{ |d,e| d != e }
  end

  def conflict?
    conflict.any?
  end

  # Returns a hash that can be used in assign_attributes
  # or update_attributes.
  def assignable_attributes
    names, to_values = fields.pluck(:name), fields.map(&:to)
    Hash[names.zip(to_values)]
  end

  private

    # Return the development's current value, paired with
    # the edit's 'from' value, partly to see if there's a conflict.
    def from_values
      fields.map { |field|
        [ development.send( field.name ), field.from ]
      }
    end

    # If there's a conflict, and we aren't explicitly ignoring it.
    def unignored_conflict?(options={})
      ignore_conflict = options.fetch(:ignore_conflict, false)
      do_not_ignore_conflict = !ignore_conflict
      conflict? && do_not_ignore_conflict
    end

    def should_save?(options={})
      options.fetch(:save, true)
    end
end
