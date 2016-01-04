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
    EditPresenter.wrap item.pending_edits.includes(:editor, :fields)
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

  def employment_type
    rptdemp ? :reported : :estimated
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

  def housing_table_fields
    %i( singfamhu twnhsmmult lgmultifam affordable )
  end

  def commercial_table_fields
    %i( fa_ret fa_ofcmd fa_indmf fa_whs fa_rnd fa_edinst fa_hotel fa_other )
  end

  def employment_table_fields
    %i( employment hotelrms )
  end

  def any_commercial_table_fields?
    any_fields? :commercial
  end

  def any_employment_table_fields?
    any_fields? :employment
  end

  def stats
    [:tothu, :commsf, :prjarea, :stories, :feet_tall]
  end

  alias_attribute :total_housing, :tothu
  alias_attribute :housing_units, :tothu
  alias_attribute :floor_area_commercial, :commsf

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

    def any_fields?(type)
      self.send("#{type}_table_fields").map{|f| item.send(f)}.compact.any?
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
