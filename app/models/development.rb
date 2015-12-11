class Development < ActiveRecord::Base
  extend Enumerize

  has_many :edits
  has_many :flags
  has_many :team_memberships, -> { group(:role).order(:role) }, class_name: :DevelopmentTeamMembership
  has_many :team_members, through: :team_memberships, source: :organization
  has_many :crosswalks
  belongs_to :creator, class_name: :User, foreign_key: :creator_id
  has_one :walkscore
  has_and_belongs_to_many :zoning_tools

  def contributors
    edits.where(state: 'applied').map(&:editor).uniq
  end

  # Break these out and require them in another file.
  @@residential_attributes = %i( affordable affunits gqpop lgmultifam
                                 ovr55 singfamhu tothu twnhsmmult )
  @@commercial_attributes = %i(
    commsf rptdemp emploss estemp fa_edinst fa_hotel fa_indmf fa_ofcmd
    fa_other fa_ret fa_rnd fa_whs othremprat )

  @@miscellaneous_attributes = %i(
      asofright cancelled clusteros created_at crosswalks desc
      location mapc_notes onsitepark phased private rdv prjarea
      project_type project_url updated_at year_compl stalled
      status total_cost name address )

  @@categorized_attributes = [@@residential_attributes,
    @@commercial_attributes, @@miscellaneous_attributes].flatten!

  serialize :fields, HashSerializer
  store_accessor :fields, @@categorized_attributes

  def tagline
    "Luxury hotel with ground floor retail."
  end

  def mixed_use?
    any_residential_attributes? && any_commercial_attributes?
  end
  # TODO: Cache this in the database.
  alias_method :mixed_use, :mixed_use?

  def history
    self.edits.where(state: 'applied').order(applied_at: :desc)
  end

  def last_edit
    history.limit(1).first
  end

  def parcel ; nil ; end

  alias_attribute :total_housing, :tothu
  alias_attribute :housing_units, :tothu
  alias_attribute :floor_area_commercial, :commsf

  private
    # TODO Remove duplicate logic
    def any_residential_attributes?
      @_any_residential ||= @@residential_attributes.map { |method|
        self.send(method)
      }.any?
    end

    def any_commercial_attributes?
      @_any_commercial ||= @@commercial_attributes.map { |method|
        self.send(method)
      }.any?
    end
end
