require 'walk_score'
require 'employment_estimator'

class Development < ActiveRecord::Base

  extend Enumerize

  include Development::ModelCallbacks
  include Development::Relationships
  include Development::Validations
  include Development::Scopes
  include Development::FieldAliases
  include Development::Location
  include Development::History
  include Development::Meta

  STATUSES = [:projected, :planning, :in_construction, :completed].freeze
  enumerize :status, in: STATUSES, predicates: true

  def to_s
    name
  end

  def mixed_use?
    tothu.to_i > 0 && commsf.to_i > 0
  end

  include PgSearch
  multisearchable against: [
    :name,
    :address,
    :tagline,
    :description,
    :place_name,
    :municipality_name
  ]

  def place_name
    place.name if place
  end

  def municipality_name
    place.municipality.name if place
  end

  private

  def nine_digit_formatted_zip(code)
    "#{code[0..4]}-#{code[-4..-1]}"
  end

end
