# Comment from models/development.rb:
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
