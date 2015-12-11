class Edit < ActiveRecord::Base
  extend Enumerize

  belongs_to :editor,    class_name: :User
  belongs_to :moderator, class_name: :User
  belongs_to :development

  validates :development, presence: true
  validates :editor, presence: true
  validates :state,  presence: true, inclusion: { in: %W( pending applied ) }

  enumerize :state, in: [:pending, :applied],
    default: :pending, predicates: true

  # Alter self.development with contents, and optionally save.
  def apply!(options={})
    should_ignore_conflict = options.fetch(:ignore_conflict, false)
    should_save = options.fetch(:save, true)
    if !should_ignore_conflict
      return false unless applyable?
    end
    apply(options)
    if should_save
      # Maybe too much responsibility?
      # Or, this should be a transaction. Feels bloated.
      development.save if self.save
    end
  end

  def apply(options={})
    if development.fields.merge assignable_fields
      applied
    else
      false
    end
  end

  def applied
    self.state = :applied
    self.applied_at = Time.now
  end

  def applyable?
    # Applyable if it's not applied and there's no conflict.
    if applied? || conflict?
      false
    else
      true
    end
  rescue StandardError => e
    puts e.inspect
    false
  end

  def not_applyable?
    !applyable?
  end

  def applied?
    state.to_sym == :applied
  end

  # "From" values in the edit are different
  # from the current values of the development
  # attributes. This doesn't necessarily invalidate
  # the entire edit, but needs to be taken into
  # account.
  def conflict?
    from_values.select{ |d,e| d != e }.any?
  end

  private
    # Returns pairs of "from" values, from development and edit,
    # in that order. All values are strings.
    # TODO: May want to make each edited field its own model,
    # to better enforce the schema.
    def from_values
      d_attrs = development.reload.fields
      self.fields.map{ |field|
        name = field.fetch('name').to_s
        edit_from  = field.fetch('from').to_s
        devel_from = d_attrs.fetch( name )
        [ devel_from, edit_from ]
      }
    end

    # Returns a hash that can be used in assign_attributes
    # or update_attributes.
    def assignable_fields
      names     = fields.map{|f| f.fetch "name" }
      to_values = fields.map{|f| f.fetch "to" }
      Hash[names.zip(to_values)]
    end
end
