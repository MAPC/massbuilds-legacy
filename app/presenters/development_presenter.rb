class DevelopmentPresenter < Burgundy::Item

  delegate :status_with_year, to: :status_info

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
    EditPresenter.wrap history.includes(:fields).limit(3)
  end

  def pending_edits
    EditPresenter.wrap item.pending_edits
  end
  alias_method :pending, :pending_edits
  def pending_edits_count
    item.pending_edits.count
  end

  # Nearby or similar developments
  def related
    # TODO make nearby / similar, instead of a simple limit
    DevelopmentPresenter.wrap Development.limit(3)
  end

  # Members of the development team
  def team
    team_memberships.includes(:organization)
      .order(:role).group_by(&:role)
  end


  # Attributes

   def stats
     [:tothu, :commsf, :prjarea, :stories, :height]
   end

  def address(options={})
    return short_address if options[:short]
    long_address
  end

  def employment
    return nil if rptdemp.nil? && estemp.nil?
    (rptdemp || estemp).to_i
  end

  def employment_type
    rptdemp ? :reported : :estimated
  end

  def status_info
    @status_info ||= StatusInfo.new(item)
  end

  # Neighborhood context (KnowPlace study)
  def neighborhood
    raise NotImplementedError, "We haven't yet implemented neighborhood context."
  end

  def disable_moderation?
    pending_edits.empty?
  end

  private

    def long_address
      "#{item.address}, #{item.city} #{item.state} #{item.zip_code}"
    end

    def short_address
      "#{item.address}, #{item.city}"
    end
end
