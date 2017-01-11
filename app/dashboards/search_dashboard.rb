require "administrate/base_dashboard"

class SearchDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    subscriptions: Field::HasMany,
    subscribers: Field::HasMany.with_options(class_name: "User"),
    id: Field::Number,
    query: Field::String.with_options(searchable: false),
    saved: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    title: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :subscriptions,
    :subscribers,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :subscriptions,
    :subscribers,
    :id,
    :query,
    :saved,
    :created_at,
    :updated_at,
    :title,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :subscriptions,
    :subscribers,
    :query,
    :saved,
    :title,
  ].freeze

  # Overwrite this method to customize how searches are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(search)
  #   "Search ##{search.id}"
  # end
end
