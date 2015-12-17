class DevelopmentPresenter < Burgundy::Item

  # Relationships

  # Everyone who has provided data for this development
  def preview_contributors
    UserPresenter.wrap item.contributors.first(5).shuffle
  end

  def contributors
    UserPresenter.wrap item.contributors.sort_by(&:last_name)
  end

  # Internal IDs for the current_user's organizations. Presented as
  # a link if the organization has a URL template; plain ID if not.
  def crosswalk_links
    # crosswalks_for(current_user)
  end

  # Last several changes, for a feed
  def recent_history
    EditPresenter.wrap history.limit(3)
  end

  def pending_edits
    EditPresenter.wrap item.pending_edits
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

  def address(options={})
    return short_address if options[:short]
    long_address
  end

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

  def disable_moderation?
    pending_edits.empty?
  end

  # def watches?(current_user)
  #   current_user.watches?(item)
  # end

  private

    def long_address
      "#{item.address}, #{item.city} #{item.state} #{item.zip_code}"
    end

    def short_address
      "#{item.address}, #{item.city}"
    end

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