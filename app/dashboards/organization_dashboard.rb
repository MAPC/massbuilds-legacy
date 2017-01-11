require "administrate/base_dashboard"

class OrganizationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    memberships: Field::HasMany,
    members: Field::HasMany.with_options(class_name: "User"),
    development_team_memberships: Field::HasMany,
    creator: Field::BelongsTo.with_options(class_name: "User"),
    place: Field::BelongsTo,
    developments: Field::HasMany,
    id: Field::Number,
    creator_id: Field::Number,
    name: Field::String,
    website: Field::String,
    url_template: Field::String,
    location: Field::String,
    email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    abbv: Field::String,
    short_name: Field::String,
    gravatar_email: Field::String,
    hashed_email: Field::String,
    municipal: Field::Boolean,
    phone: Field::String,
    address: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :memberships,
    :members,
    :development_team_memberships,
    :creator,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :memberships,
    :members,
    :development_team_memberships,
    :creator,
    :place,
    :developments,
    :id,
    :creator_id,
    :name,
    :website,
    :url_template,
    :location,
    :email,
    :created_at,
    :updated_at,
    :abbv,
    :short_name,
    :gravatar_email,
    :hashed_email,
    :municipal,
    :phone,
    :address,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :memberships,
    :members,
    :development_team_memberships,
    :creator,
    :place,
    :developments,
    :creator_id,
    :name,
    :website,
    :url_template,
    :location,
    :email,
    :abbv,
    :short_name,
    :gravatar_email,
    :hashed_email,
    :municipal,
    :phone,
    :address,
  ].freeze

  # Overwrite this method to customize how organizations are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(organization)
  #   "Organization ##{organization.id}"
  # end
end
