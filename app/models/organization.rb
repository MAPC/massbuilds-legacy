class Organization < ActiveRecord::Base

  before_save :hash_email
  after_create :create_admin_membership

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  # has_many :administrators, class_name: :User, dependent: :nullify
  has_many :development_team_memberships, dependent: :destroy

  # has_many :crosswalks, dependent: :nullify

  # This should be scoped for unique, but our Postgres version (9.3)
  # cannot SELECT DISTINCT on tables with JSON data types.
  has_many :developments, through: :development_team_memberships
  belongs_to :creator, class_name: :User

  # Must have a place (Municipality) if it is a municipal organization
  belongs_to :place, -> { where type: 'Municipality' }
  validates  :place, presence: true, if: 'municipal?'

  validates :name,       presence: true
  # validates :website,    presence: true
  validates :short_name, presence: true

  validates :creator, presence: true
  validate  :valid_email, if: 'email.present?'
  validate  :valid_url_template, if: 'url_template.present?'

  # TODO: validates :existence_of_website

  alias_attribute :admin, :creator

  def self.search(text)
    where('name ILIKE ?', "%#{text}%");
  end

  def self.municipal
    where municipal: true
  end

  def self.municipal_in(place)
    municipal.where(place_id: place.municipality.id)
  end

  # Look up admin organizations, as specified by comma-separated ENV var.
  def self.admin
    where id: ENV['ADMIN_ORG_IDS'].to_s.split(',')
  end

  def admins
    members.joins(:memberships).where(memberships: { role: :admin })
  end

  def active_members
    memberships.active.map(&:user).uniq
  end

  def url_parser
    URITemplate.new(url_template)
  end

  def has_url_template?
    url_template.present?
  end

  def developments
    DevelopmentTeamMembership.where(organization_id: id).
      includes(:development).map(&:development).uniq
  end

  def gravatar_url
    @gravatar_url ||= "https://secure.gravatar.com/avatar/#{hashed_email}?d=identicon"
  end

  alias_method :logo, :gravatar_url

  def to_s
    name
  end

  private

  def valid_email
    addr = Mail::Address.new(email)
    throw StandardError if [addr.local, addr.domain].include?(nil)
  rescue
    errors.add(:email, 'must be a valid email address')
  end

  def valid_url_template
    template = URITemplate.new(url_template.to_s)
    url_variables = template.tokens.map(&:variables).flatten
    if url_variables.exclude? 'id'
      errors.add(:url_template, "must include '{id}' somewhere")
    end
  end

  def hash_email
    attribute_to_hash = [gravatar_email, email, name].detect(&:present?).to_s.downcase
    self.hashed_email = Digest::MD5.hexdigest(attribute_to_hash)
  end

  def create_admin_membership
    self.memberships.create!(user: creator, state: :active, role: :admin)
  end

end
