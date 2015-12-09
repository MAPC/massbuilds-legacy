class Development < ActiveRecord::Base
  has_many :edits
  has_many :flags
  # has_many :contributors, through: :edits, scope: :approved
  # has_many :team_memberships, class_name: :DevelopmentTeamMemberships
  # has_many :team_members, through: :team_memberships, class_name: :Organizations
  # has_many :crosswalks

  serialize :fields, HashSerializer
  store_accessor :fields, :name, :address, :housing_units

  # TODO Add definitions, metadata. Might be YML, could be in
  # config/locales.

  def status
    "In Construction"
  end
  def complyr
    2016
  end
  def tagline
    "Luxury hotel with street-level retail."
  end
  def retail_sq_ft
    10_264
  end
  def housing_units
    100
  end

  # TODO: Move to presenter
  def status_with_year
    if status == "Completed"
      "#{status} (#{complyr_actual})"
    else
      "#{status} (est. #{complyr})"
    end
  end

  def history
    # Should be paginatable.
    # Oh, it's belongs as a separate resource, paginateable.
    self.edits.where(state: 'applied').order(:date)
  end

  def pending
    # See note in #history
    self.edits.where(state: 'pending').order(:date)
  end

  def crosswalks
    crosswalks_for(User.null)
  end

  def crosswalks_for(user)
    []
    # TODO
    # First, this belongs in a presenter. Add Burgundy
    # (https://github.com/fnando/burgundy) to the Gemfile and create presenters.
    # #crosswalks gets all the organizations in common with both
    # the development and the current_user.
    # development.crosswalks.where(organization_id in user.organization.ids).uniq
    # Then wrap them in a link if the organization has a URL template,
    # or leave them as text if not.
  end

  # TODO as we add more fields, potentially
  # def method_missing(method_name, *arguments, &block)
  #   fields.send(:fetch, method_name, &block)
  # rescue
  #   super
  # end
  # From https://robots.thoughtbot.com/always-define-respond-to-missing-when-overriding
  # def respond_to_missing?(method_name, include_private = false)
  #   method_name.to_s.start_with?('user_') || super
  # end
end

=begin

rails g model DevelopmentTeamMembership development:belongs_to organization:belongs_to role:string|belongs_to if we make Role a database entity.
rails g model Crosswalk development:belongs_to organization:belongs_to internal_id:string

=end