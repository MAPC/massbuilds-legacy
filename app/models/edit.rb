class Edit < ActiveRecord::Base
  extend Enumerize

  belongs_to :editor,    class_name: :User
  belongs_to :moderator, class_name: :User
  belongs_to :development

  validates :development, presence: true
  validates :editor, presence: true
  validates :state,  presence: true, inclusion: { in: %W( pending applied ) }

  enumerize :state, in: [:pending, :applied], default: :pending, predicates: true

  serialize :fields, CollectionSerializer

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
    if development.fields.merge!(assignable_fields)
      applied
    else
      false
    end
  end

  def applied
    self.applied_at = Time.now
    self.state = :applied
  end

  def applyable?
    # Applyable if it's not applied and there's no conflict.
    if applied? || conflict?
      false
    else
      true
    end
  rescue StandardError => e
    puts " APPLYABLE ERROR "
    puts e.inspect
    false
  end

  def not_applyable?
    !applyable?
  end

  # "From" values in the edit are different
  # from the current values of the development
  # attributes. This doesn't necessarily invalidate
  # the entire edit, but needs to be taken into
  # account.
  def conflict?
    conflict.any?
  end

  def conflict
    from_values.select{ |d,e| d != e }
  end

  # Returns a hash that can be used in assign_attributes
    # or update_attributes.
  def assignable_fields
    names     = fields.map{|f| f.fetch "name" }
    to_values = fields.map{|f| f.fetch "to" }
    Hash[names.zip(to_values)] #=> [{"commsf" => 1000}]
  end

  private
    # Returns pairs of "from" values, from development and edit,
    # in that order. All values are strings.
    # TODO: May want to make each edited field its own model,
    # to better enforce the schema.
    def from_values
      d_attrs = development.fields
      self.fields.map{ |field|
        name = field.fetch('name').to_s
        edit_from  = field.fetch('from')
        devel_from = d_attrs.fetch( name )
        [ devel_from, edit_from ]
      }
    end



    def unignored_conflict?(options={})
      ignore_conflict = options.fetch(:ignore_conflict, false)
      do_not_ignore_conflict = !ignore_conflict
      conflict? && do_not_ignore_conflict
    end

    def should_save?(options={})
      options.fetch(:save, true)
    end
end
