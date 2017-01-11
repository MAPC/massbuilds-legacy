require "administrate/base_dashboard"

class ClaimDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    claimant: Field::BelongsTo.with_options(class_name: "User"),
    development: Field::BelongsTo,
    moderator: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    claimant_id: Field::Number,
    moderator_id: Field::Number,
    role: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    reason: Field::String,
    state: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :claimant,
    :development,
    :moderator,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :claimant,
    :development,
    :moderator,
    :id,
    :claimant_id,
    :moderator_id,
    :role,
    :created_at,
    :updated_at,
    :reason,
    :state,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :claimant,
    :development,
    :moderator,
    :claimant_id,
    :moderator_id,
    :role,
    :reason,
    :state,
  ].freeze

  # Overwrite this method to customize how claims are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(claim)
  #   "Claim ##{claim.id}"
  # end
end
