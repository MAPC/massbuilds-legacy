class Municipality < Place
  has_many :neighborhoods, foreign_key: :place_id, class_name: 'Place'
end
