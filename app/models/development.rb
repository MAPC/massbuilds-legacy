class Development < ActiveRecord::Base
  has_many :edits
  has_many :flags

  # The #apply_edit methods doesn't really belong here, does it?
  # It's not a model, but maybe it's a service object,
  # like Approval / Rejection.

  # def apply_edit(edit)
  #   if edit.not_applyable?
  #     raise StandardError, "Edit is not applyable."
  #   else
  #     edit.apply
  #   end
  # end

  def history
    # Should be paginatable.
    # Oh, it's belongs as a separate resource, paginateable.
    self.edits.where(state: 'applied').order(:date)
  end
end
