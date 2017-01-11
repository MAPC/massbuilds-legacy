require "administrate/base_dashboard"

class MunicipalityDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    developments: Field::HasMany,
    pg_search_document: Field::HasOne,
    neighborhoods: Field::HasMany.with_options(class_name: "Place"),
    id: Field::Number,
    name: Field::String,
    type: Field::String,
    place_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    geom: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :developments,
    :pg_search_document,
    :neighborhoods,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :developments,
    :pg_search_document,
    :neighborhoods,
    :id,
    :name,
    :type,
    :place_id,
    :created_at,
    :updated_at,
    :geom,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :developments,
    :pg_search_document,
    :neighborhoods,
    :name,
    :type,
    :place_id,
    :geom,
  ].freeze

  # Overwrite this method to customize how municipalities are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(municipality)
  #   "Municipality ##{municipality.id}"
  # end
end
