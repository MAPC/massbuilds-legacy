require 'walk_score'
class Development < ActiveRecord::Base

  extend Enumerize

  # include Development::Callbacks
  # include Development::Relationships
  # include Development::Validations
  # include Development::Scopes

  # Callbacks
  before_save :clean_zip_code
  before_save :associate_place
  before_save :cache_street_view
  before_save :update_walk_score

  # Relationships
  belongs_to :creator, class_name: :User
  belongs_to :place

  has_many :edits
  has_many :flags
  has_many :crosswalks

  has_many :team_memberships,
    class_name:    :DevelopmentTeamMembership,
    counter_cache: :team_membership_count,
    dependent:     :destroy

  has_many :team_members, through: :team_memberships, source: :organization
  has_many :moderators,   through: :team_members,     source: :members

  has_many :subscriptions, as: :subscribable
  has_many :subscribers,   through: :subscriptions, source: :user

  has_and_belongs_to_many :programs

  # Validations
  validates :creator,    presence: true
  validates :year_compl, presence: true
  validates :tagline,     allow_blank: true, length: { minimum: 40,  maximum: 140 }
  validates :description, allow_blank: true, length: { minimum: 141, maximum: 500 }

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
  default_scope { includes(:place) }

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

  def neighborhood
    place.neighborhood if place
  end

  def municipality
    place.municipality if place
  end

  alias_method :city, :municipality

  def parcel
    OpenStruct.new(id: 123)
  end

  def street_view
    @street_view ||= StreetView.new(self)
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

  def associate_place
    if location_fields_changed? || new_record?
      places = Place.contains(lat: latitude, lon: longitude)
      if places.empty?
        Airbrake.notify('No place found', self) if defined?(Airbrake)
        self.place = nil
      else
        self.place = places.first
      end
    end
  end

  def cache_street_view
    if street_view_fields_changed? || new_record?
      self.street_view_image = street_view.image(cached: false)
    end
  end

  def update_walk_score
    if location_fields_changed? || new_record?
      self.walkscore = WalkScore.new(lat: latitude, lon: longitude).to_h
    end
  end

  def location_fields_changed?
    [:latitude, :longitude, :street_view_latitude, :street_view_longitude].select { |f|
      send("#{f}_changed?")
    }.any?
  end

  def street_view_fields_changed?
    [:latitude, :longitude, :pitch, :heading].select { |field|
      send("street_view_#{field}_changed?")
    }.any?
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
