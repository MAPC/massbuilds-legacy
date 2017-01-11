require "administrate/base_dashboard"

class EditDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    fields: Field::String.with_options(searchable: false),
    editor: Field::BelongsTo.with_options(class_name: "User"),
    moderator: Field::BelongsTo.with_options(class_name: "User"),
    development: Field::BelongsTo,
    id: Field::Number,
    editor_id: Field::Number,
    moderator_id: Field::Number,
    state: Field::String,
    fields: Field::String.with_options(searchable: false),
    applied_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    ignore_conflicts: Field::Boolean,
    moderated_at: Field::DateTime,
    applied: Field::Boolean,
    log_entry: Field::Text,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :fields,
    :editor,
    :moderator,
    :development,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :fields,
    :editor,
    :moderator,
    :development,
    :id,
    :editor_id,
    :moderator_id,
    :state,
    :fields,
    :applied_at,
    :created_at,
    :updated_at,
    :ignore_conflicts,
    :moderated_at,
    :applied,
    :log_entry,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :fields,
    :editor,
    :moderator,
    :development,
    :editor_id,
    :moderator_id,
    :state,
    :fields,
    :applied_at,
    :ignore_conflicts,
    :moderated_at,
    :applied,
    :log_entry,
  ].freeze

  # Overwrite this method to customize how edits are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(edit)
  #   "Edit ##{edit.id}"
  # end
end
