class Development
  module Relationships
    extend ActiveSupport::Concern

    included do
      belongs_to :creator, class_name: :User
      belongs_to :place

      has_many :edits, dependent: :destroy
      has_many :flags, dependent: :destroy
      # has_many :crosswalks

      has_many :editors, -> { where edits: { applied: true } },
        through:    :edits,
        class_name: :User

      has_many :team_memberships,
        class_name:    :DevelopmentTeamMembership,
        counter_cache: :team_membership_count,
        dependent:     :destroy

      has_many :team_members, through: :team_memberships, source: :organization

      # This relationship name is only accurate if the organization is municipal.
      # Since the check is on the user model (#moderator_for?), we don't change
      # the scope here.
      has_many :moderators, through: :team_members, source: :members

      has_many :subscriptions, as: :subscribable
      has_many :subscribers,   through: :subscriptions, source: :user

      # has_and_belongs_to_many :programs
      enumerize :programs, in: {
        "40B" => 1,
        "40R" => 2,
        "43D" => 3,
        "MassWorks Infrastructure Program" => 4
      }, multiple: true
      serialize :programs, Array
    end

  end
end
