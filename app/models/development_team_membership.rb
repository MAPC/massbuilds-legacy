class DevelopmentTeamMembership < ActiveRecord::Base
  extend Enumerize

  belongs_to :development
  belongs_to :organization

  validates :development, presence: true
  validates :organization, presence: true

  @@roles = { developer: 1, architect: 2, engineer: 3,
             contractor: 4, landlord: 5, owner: 6 }

  enumerize :role, :in => @@roles, predicates: true

end
