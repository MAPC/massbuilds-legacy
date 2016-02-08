class Place < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 65 }
end
