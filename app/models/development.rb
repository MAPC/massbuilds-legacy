class Development < ActiveRecord::Base
  extend Enumerize

  before_save :update_tagline
  before_save :clean_zip_code

  belongs_to :creator, class_name: :User
  has_one :walkscore # TODO

  has_many :edits
  has_many :flags
  has_many :crosswalks
  has_many :team_memberships, class_name: :DevelopmentTeamMembership
  has_many :team_members, through: :team_memberships, source: :organization

  has_and_belongs_to_many :programs

  validates :creator, presence: true

  serialize :fields, HashSerializer
  # Should get from self.all_fields, but comes up as nil.
  store_accessor :fields, [:mixeduse, :private, :cancelled,
    :fa_ret, :fa_ofcmd, :fa_indmf, :fa_whs, :fa_rnd, :fa_edinst,
    :fa_other, :other_rate, :fa_hotel,
    :affunits, :affordable,
    :location, :ch40_id, :project_type]

  STATUSES = [:projected, :planning, :in_construction, :completed]
  enumerize :status, :in => STATUSES, predicates: true

  alias_attribute :website, :project_url
  alias_attribute :zip, :zip_code

  def zip_code
    code = read_attribute(:zip_code).to_s
    if code.length == 9
      "#{code[0..4]}-#{code[-4..-1]}"
    else
      code
    end
  end

  def mixed_use?
    any_residential_fields? && any_commercial_fields?
  end
  # TODO: Cache this in the database, to be used for searches.
  alias_method :mixed_use, :mixed_use?

  def history
    self.edits.where(state: 'applied').order(applied_at: :desc)
  end

  def pending_edits
    self.edits.where(state: 'pending').order(created_at: :asc)
  end

  def contributors
    _contributors = edits.where(state: 'applied').map(&:editor)
    _contributors << creator
    _contributors.uniq
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

  def private?   ; read_attribute(:private) ; end

  private

    def update_tagline
      self.tagline = TaglineGenerator.new(self).perform!
    end

    def clean_zip_code
      self.zip_code = self.zip_code.to_s.gsub(/\D*/, '')
    end
end
