class Development < ActiveRecord::Base
  # TODO: basic geocoding
  # geocoded_by :full_street_address   # Implement this method
  # after_validation :geocode          # Auto-fetch coordinates
  has_one :walkscore # TODO

  extend Enumerize

  # include Development::Validations
  # include Development::Scopes

  # Callbacks
  before_save :update_tagline
  before_save :clean_zip_code
  before_save :cache_street_view

  # Relationships
  belongs_to :creator, class_name: :User
  belongs_to :place

  has_many :edits, dependent: :nullify
  has_many :flags, dependent: :nullify
  has_many :crosswalks, dependent: :nullify
  has_many :team_memberships, class_name: :DevelopmentTeamMembership,
    counter_cache: :team_membership_count, dependent: :destroy
  has_many :team_members, through: :team_memberships, source: :organization
  has_many :moderators, through: :team_members, source: :members
  has_many :subscriptions, as: :subscribable,
    dependent: :nullify
  has_many :subscribers, through: :subscriptions, source: :user,
    dependent: :nullify

  has_and_belongs_to_many :programs

  default_scope { includes(:place) }

  # Validations
  validates :creator,    presence: true
  validates :year_compl, presence: true

  lat_range = { less_than_or_equal_to:  90, greater_than_or_equal_to:  -90 }
  lon_range = { less_than_or_equal_to: 180, greater_than_or_equal_to: -180 }

  validates :latitude,  presence: true, numericality: lat_range
  validates :longitude, presence: true, numericality: lon_range

  validates :street_view_latitude,  allow_blank: true, numericality: lat_range
  validates :street_view_longitude, allow_blank: true, numericality: lon_range

  STATUSES = [:projected, :planning, :in_construction, :completed].freeze
  enumerize :status, in: STATUSES, predicates: true

  alias_attribute :description, :desc
  alias_attribute :website,     :project_url
  alias_attribute :zip,         :zip_code
  alias_attribute :hidden,      :private

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
    [latitude, longitude].map(&:to_f)
  end

  def rlocation
    location.reverse
  end

  def zip_code
    code = read_attribute(:zip_code).to_s
    code.length == 9 ? nine_digit_formatted_zip(code) : code
  end

  def municipality
    return nil unless place
    case place.type
    when 'Municipality' then place
    when 'Neighborhood' then place.municipality
    else raise NotImplementedError, "type not defined in #{__FILE__}"
    end
  end

  alias_method :city, :municipality

  def neighborhood
    return nil unless place
    case place.type
    when 'Neighborhood' then place
    when 'Municipality' then nil
    end
  end

  def mixed_use?
    false
    # any_residential_fields? && any_commercial_fields?
  end
  # TODO: Cache this in the database, to be used for searches.
  alias_method :mixed_use, :mixed_use?

  def history
    edits.applied
  end

  def pending_edits
    edits.where(state: 'pending').order(created_at: :asc)
  end

  def contributors
    ContributorQuery.new(self).find.map(&:editor).push(creator).uniq
  end

  def street_view
    @street_view ||= StreetView.new(self)
  end

  def parcel
    OpenStruct.new(id: 123)
  end

  def updated_since?(time = Time.now)
    history.since(time).any? ? true : created_since?(time)
  end

  def created_since?(time = Time.now)
    created_at > time
  end

  def self.ranged_column_bounds
    Hash[ranged_column_array]
  end

  def to_s
    name
  end

  private

  def cache_street_view
    if street_view_fields_changed?
      self.street_view_image = street_view.image(cached: false)
    end
  end

  def street_view_fields_changed?
    [:latitude, :longitude, :pitch, :heading].select { |field|
      send("street_view_#{field}_changed?")
    }.any?
  end

  def update_tagline
    self.tagline = TaglineGenerator.new(self).perform!
  end

  def clean_zip_code
    zip_code.to_s.gsub!(/\D*/, '') # Only digits
  end

  def nine_digit_formatted_zip(code)
    "#{code[0..4]}-#{code[-4..-1]}"
  end

  private_class_method def self.ranged_column_array
    columns.map { |c| column_range(c) unless exclude_from_ranges?(c) }.compact
  end

  private_class_method def self.column_range(col)
    minmax = {
      max: Development.maximum(col.name),
      min: Development.minimum(col.name)
    }
    [col.name.to_sym, minmax]
  end

  private_class_method def self.exclude_from_ranges?(col)
    exclude_reg = /^street_view_|^id$|_id$/
    include_reg = /(integer|double|timestamp|numeric)/i
    exclude_reg.match(col.name.to_s) || !include_reg.match(col.sql_type.to_s)
  end

end
