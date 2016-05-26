class Development
  module Relationships
    extend ActiveSupport::Concern

    included do
      belongs_to :creator, class_name: :User
      belongs_to :place

      has_many :edits, dependent: :destroy
      has_many :flags, dependent: :destroy
      has_many :crosswalks

      has_many :team_memberships,
        class_name:    :DevelopmentTeamMembership,
        counter_cache: :team_membership_count,
        dependent:     :destroy

      has_many :team_members, through: :team_memberships, source: :organization
      has_many :moderators,   through: :team_members,     source: :members

      has_many :subscriptions, as: :subscribable
      has_many :subscribers,   through: :subscriptions, source: :user

      has_and_belongs_to_many :programs
    end

  end
end
