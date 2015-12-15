class DevelopmentPresenter < Burgundy::Item

  # Relationships

  # Everyone who has provided data for this development
  def contributors
    # TODO Wrap contributors in ContributorPresenter
    %w( mark lena lindsay molly eve ).shuffle
    # item.contributors.first(5) # TODO Optimize query instead of getting all contributors
  end

  # Internal IDs for the current_user's organizations. Presented as
  # a link if the organization has a URL template; plain ID if not.
  def crosswalk_links
    # crosswalks_for(current_user)
  end

  # Last several changes, for a feed
  def recent_history
    history.limit(3)
  end

  # Nearby or similar developments
  def related
    # TODO make nearby / similar, instead of a simple limit
    DevelopmentPresenter.wrap Development.limit(3)
  end

  # Members of the development team
  def team
    team_memberships.order(:role).group_by(&:role)
  end


  # Attributes

  def employment
    return nil if rptdemp.nil? && estemp.nil?
    (rptdemp || estemp).to_i
  end

  def status_with_year
    if completed?
      "#{status.titleize} (#{year_compl})"
    else
      "#{status.titleize} (est. #{year_compl})"
    end
  end

  # Neighborhood context (KnowPlace study)
  def neighborhood
    raise NotImplementedError, "We haven't yet implemented neighborhood context."
  end

  # def watches?(current_user)
  #   current_user.watches?(item)
  # end

  # private

  #   def crosswalks_for(user)
  #     []
  #   end

  #   # TODO Not sure where to put this logic.
  #   # Probably back in the model.
  #   def watches?
  #     false
  #   end

end

# TODO displaying units and percents on numeric data
# May create helper methods to be used to determine whether user
# can flag, claim, edit, or watch, if it gets confusing in the template.
