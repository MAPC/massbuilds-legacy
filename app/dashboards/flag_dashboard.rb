require "administrate/base_dashboard"

class FlagDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    development: Field::BelongsTo,
    flagger: Field::BelongsTo.with_options(class_name: "User"),
    resolver: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    flagger_id: Field::Number,
    reason: Field::Text,
    state: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    resolver_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :development,
    :flagger,
    :resolver,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :development,
    :flagger,
    :resolver,
    :id,
    :flagger_id,
    :reason,
    :state,
    :created_at,
    :updated_at,
    :resolver_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :development,
    :flagger,
    :resolver,
    :flagger_id,
    :reason,
    :state,
    :resolver_id,
  ].freeze

  # Overwrite this method to customize how flags are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(flag)
  #   "Flag ##{flag.id}"
  # end
end
