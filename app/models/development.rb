class Development < ActiveRecord::Base
  extend Enumerize

  belongs_to :creator, class_name: :User
  has_one :walkscore # < How did Christian set this up?

  has_many :edits
  has_many :flags
  has_many :crosswalks
  has_many :team_memberships, -> { group(:role).order(:role) }, class_name: :DevelopmentTeamMembership
  has_many :team_members, through: :team_memberships, source: :organization

  has_and_belongs_to_many :programs

  def contributors
    edits.where(state: 'applied').map(&:editor).uniq
  end

  validates :creator, presence: true

  # Break these out and require them in another file.
  @@residential_attributes = %i( affordable affunits gqpop lgmultifam
                                 ovr55 singfamhu tothu twnhsmmult )
  @@commercial_attributes = %i(
    commsf rptdemp emploss estemp fa_edinst fa_hotel fa_indmf fa_ofcmd
    fa_other fa_ret fa_rnd fa_whs othremprat )

  @@miscellaneous_attributes = %i(
      asofright cancelled clusteros created_at desc
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

  def incentive_programs
    programs.where(type: :incentive)
  end

  def regulatory_programs
    programs.where(type: :regulatory)
  end

  alias_attribute :total_housing, :tothu
  alias_attribute :housing_units, :tothu
  alias_attribute :floor_area_commercial, :commsf

  private

    def any_residential_attributes?
      @_any_residential ||= any_attributes(:residential).any?
    end
    def any_commercial_attributes?
      @_any_commercial  ||= any_attributes(:commercial).any?
    end
    def any_attributes(type)
      Development.class_variable_get("@@#{type}_attributes").map {|m| self.send(m)}
    end
end
