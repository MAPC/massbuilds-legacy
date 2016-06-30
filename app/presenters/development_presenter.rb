class DevelopmentPresenter < Burgundy::Item

  delegate :status_with_year, :status_icon, to: :status_info
  NUM_CHANGES = 3 # to display

  # Relationships

  # Everyone who has provided data for this development
  def preview_contributors
    UserPresenter.wrap item.contributors.first(5).shuffle
  end

  def contributors
    UserPresenter.wrap item.contributors.sort_by(&:last_name)
  end

  # Last several changes, for a feed
  def recent_history
    EditPresenter.wrap history.includes(:fields).limit(NUM_CHANGES)
  end

  def pending_edits
    EditPresenter.wrap item.edits.pending
  end

  def pending_flags
    FlagPresenter.wrap item.flags.where(state: :open)
  end

  def changes_since(timestamp = Time.now)
    EditPresenter.wrap item.history.since(timestamp).first(NUM_CHANGES)
  end

  def undisplayed_changes_since(timestamp = Time.now)
    item.history.since(timestamp).count - NUM_CHANGES
  end

  alias_method :pending, :pending_edits

  def pending_edits_count
    item.edits.pending.count
  end

  # Nearby or similar developments
  def related
    DevelopmentPresenter.wrap(
      Development.close_to(*item.location).where.not(id: item.id).limit(3)
    )
  end

  # Members of the development team
  def team
    team_memberships.
      includes(:organization).
      order(:role).
      group_by(&:role)
  end

  def display_address(options = {})
    options[:short] ? short_address : long_address
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
    raise NotImplementedError,
      'We have not yet implemented neighborhood context.'
  end

  def disable_moderation?
    pending_edits.empty?
  end

  def physical_attributes
    category_attributes :physical
  end

  def housing_attributes
    category_attributes :housing
  end

  def commercial_attributes
    category_attributes :commercial
  end

  def place_org
    Organization.municipal.find_by(place_id: item.place_id)
  end

  private

  def long_address
    "#{item.address}, #{item.city} #{item.state} #{item.zip_code}"
  end

  def short_address
    "#{item.address}, #{item.city}"
  end

  def category_attributes(category)
    item.attributes.select do |k, v|
      categorized_attributes.fetch(category, {}).include?(k.to_sym) && !v.nil?
    end
  end

  def categorized_attributes
    {
      physical:   [:tothu, :commsf, :prjarea, :stories, :height],
      housing:    [:singfamhu, :twnhsmmult, :lgmultifam],
      commercial: [
        :fa_ret,   :fa_ofcmd, :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst,
        :fa_other, :fa_hotel
      ]
    }
  end

end
