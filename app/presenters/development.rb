class DevelopmentPresenter

  def initialize(development)
    assert_presentable_development(development)
    @development = development
  end

  def assert_presentable_development(development)
    unless development.is_a? Development
      raise ArgumentError, "#{development} must be a Development."
    end
  end
=begin

  Presents all of the information for the development/show template.
  Needs:

  @development
    .team           => all members of the development team
    .contributors   => everyone who has edited this development, grouped by role
                        This may link to a contributors presenter
                        May include anyone who's moderated edits to this development
    .related        => three nearby or similar developments
    .recent_history => last three changes
    .context        => neighborhood context, ready to be rendered
    .tagline        => This may be where the tagline is constructed.

  Deals with attribute presentation logic, such as
    - choosing between actual and reported employment
    - displaying units and percents
    - forming the Status & Year field

  May create helper methods to be used to determine whether user
  can flag, claim, edit, or watch, if it gets confusing in the template.

  Will also need to know whether current_user.watches?(@development)

  def recent_history
    @development.history.limit(3)
  end

  # CODE
  def status_with_year
    if status == "Completed"
      "#{status} (#{complyr})"
    else
      "#{status} (est. #{complyr})"
    end
  end

  def employment
  end

  def crosswalks
    crosswalks_for(User.null)
  end

  def crosswalks_for(user)
    @development.crosswalks.where(
      organization IN user.organizations
    )
  end


=end

end


# TODO
# First, this belongs in a presenter. Add Burgundy
# (https://github.com/fnando/burgundy) to the Gemfile and create presenters.
# #crosswalks gets all the organizations in common with both
# the development and the current_user.
# development.crosswalks.where(organization_id in user.organization.ids).uniq
# Then wrap them in a link if the organization has a URL template,
# or leave them as text if not.