class Neighborhood < Place
  belongs_to :municipality, foreign_key: :place_id, class_name: 'Place'

  default_scope { includes :municipality }
end
