class Development < ActiveRecord::Base
  # TODO: basic geocoding
  # geocoded_by :full_street_address   # Implement this method
  # after_validation :geocode          # Auto-fetch coordinates
  has_one :walkscore # TODO

  extend Enumerize

  # Callbacks
  before_save :update_tagline
  before_save :clean_zip_code

  # Relationships
  belongs_to :creator, class_name: :User
  has_many :edits
  has_many :flags
  has_many :crosswalks
  has_many :team_memberships, class_name: :DevelopmentTeamMembership,
            counter_cache: :team_membership_count
  has_many :team_members, through: :team_memberships, source: :organization
  has_and_belongs_to_many :programs

  # Validations
  validates :creator,    presence: true
  validates :year_compl, presence: true

  STATUSES = [:projected, :planning, :in_construction, :completed]
  enumerize :status, :in => STATUSES, predicates: true

  alias_attribute :website, :project_url
  alias_attribute :zip, :zip_code
  alias_attribute :hidden, :private

  # Scopes
  ranged_scopes :created_at, :updated_at, :height, :stories,
    :year_compl, :affordable, :prjarea, :singfamhu, :twnhsmmult,
    :lgmultifam, :tothu, :gqpop, :rptdemp, :emploss, :estemp, :commsf,
    :hotelrms, :onsitepark, :total_cost, :fa_ret, :fa_ofcmd,
    :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst, :fa_other, :fa_hotel

  boolean_scopes :rdv, :asofright, :ovr55, :clusteros, :phased,
    :stalled, :cancelled, :hidden

  scope :close_to, CloseToQuery.new(self).scope

  def location
    [longitude.to_f, latitude.to_f]
  end

  def zip_code
    code = read_attribute(:zip_code).to_s
    code.length == 9 ? nine_digit_formatted_zip(code) : code
  end

  def mixed_use?
    false
    # any_residential_fields? && any_commercial_fields?
  end
  # TODO: Cache this in the database, to be used for searches.
  alias_method :mixed_use, :mixed_use?

  def history
    self.edits.where(applied: true).order(applied_at: :desc)
  end

  def pending_edits
    self.edits.where(state: 'pending').order(created_at: :asc)
  end

  def contributors
    ContributorQuery.new(self).find.map(&:editor).push(creator).uniq
  end

  def parcel
    OpenStruct.new(id: 12345)
  end

  def incentive_programs
    programs.where type: :incentive
  end

  def regulatory_programs
    programs.where type: :regulatory
  end

  private

    def update_tagline
      self.tagline = TaglineGenerator.new(self).perform!
    end

    def clean_zip_code
      self.zip_code = self.zip_code.to_s.gsub(/\D*/, '')
    end

    def nine_digit_formatted_zip(code)
      "#{code[0..4]}-#{code[-4..-1]}"
    end
end
