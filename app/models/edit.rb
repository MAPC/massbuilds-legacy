class Edit < ActiveRecord::Base
  belongs_to :editor,    class_name: :User
  belongs_to :moderator, class_name: :User
  belongs_to :development

  # Alter self.development with contents, and optionally save.
  def apply(options={})
    should_ignore_conflict = options.fetch(:ignore_conflict, false)
    should_save = options.fetch(:save, true)
    if !should_ignore_conflict
      return false unless applyable?
    end
    # TODO Align with Process Object best practice
    if development.assign_attributes(assignable_attributes)
      edit.state = :applied
    end
    if should_save
      development.save if self.save # Maybe too much?
    end
  end

  def applyable?
    # Check that it's not already applied
    # and that there's no merge conflict
    return false if applied? || conflict?
  rescue StandardError => e
    log(e.level, e.message)
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
    self.from_values.select{ |d,e| d != e }.any?
  end

  private
    # Returns pairs of "from" values, from development and edit,
    # in that order. All values are strings.
    def from_values
      d_attrs = development.reload.attributes
      self.fields.map{|f|
        # TODO: Make this clearer
        [ d_attrs.send(f).to_s, f.fetch('from').to_s ]
      }
    end

    # Returns a hash that can be used in assign_attributes
    # or update_attributes.
    def assignable_attributes
      names     = fields.map{|f| f.fetch "name" }
      to_values = fields.map{|f| f.fetch "to" }
      Hash[names.zip(to_values)]
    end
end
