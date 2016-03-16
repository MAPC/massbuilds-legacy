class DevelopmentPresenter < Burgundy::Item

  delegate :status_with_year, :status_icon, to: :status_info
  CHANGES_TO_SHOW = 3

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
    EditPresenter.wrap history.includes(:fields).limit(CHANGES_TO_SHOW)
  end

  def pending_edits
    EditPresenter.wrap item.pending_edits
  end

  def changes_since(timestamp = Time.now)
    EditPresenter.wrap item.changes_since(timestamp).first(CHANGES_TO_SHOW)
  end

  def undisplayed_changes_since(timestamp = Time.now)
    item.changes_since(timestamp).count - CHANGES_TO_SHOW
  end

  alias_method :pending, :pending_edits

  def pending_edits_count
    item.pending_edits.count
  end

  # Nearby or similar developments
  def related
    DevelopmentPresenter.wrap(
      Development.close_to(*item.location).
        where.not(id: item.id).limit(3).includes(:place))
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

  def street_view(*args)
    # TODO: Move this into its own class.
    return nil if Rails.env == 'test'
    w, h = 600, 600
    w, h = 80, 70 if args.include? :tiny
    url = 'https://maps.googleapis.com/maps/api/streetview?'
    url << "size=#{w}x#{h}"
    url << "&location=#{location.join(',')}"
    url << '&fov=100&heading=235&pitch=35'
    url << '&key=AIzaSyA-kZB6mH1kp-uXBrp5v8luDiPzKYh_nfQ'
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

  private

  def long_address
    "#{item.address}, #{item.city} #{item.state} #{item.zip_code}"
  end

  def short_address
    "#{item.address}, #{item.city}"
  end

  def category_attributes(category)
    item.attributes.select { |k, v|
      categorized_attributes.fetch(category, {}).include?(k.to_sym) && !v.nil?
    }
  end

  def categorized_attributes
    { physical:   [:tothu, :commsf, :prjarea, :stories, :height],
      housing:    [:singfamhu, :twnhsmmult, :lgmultifam, :tothu],
      commercial: [:fa_ret, :fa_ofcmd, :fa_indmf, :fa_whs, :fa_rnd,
        :fa_edinst, :fa_other, :fa_hotel] }
  end


end
