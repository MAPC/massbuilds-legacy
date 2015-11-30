class Organization < ActiveRecord::Base
  has_many :members,        class_name: :User
  has_many :administrators, class_name: :User
  belongs_to :creator,      class_name: :User

  validates :name, presence: true
  validates :website, presence: true
  validates :short_name, presence: true

  validates :creator, presence: true

  # validates :existence_of_url
end
