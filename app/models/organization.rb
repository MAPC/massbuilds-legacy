class Organization < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :administrators, class_name: :User
  has_many :crosswalks
  has_many :development_team_memberships

  # this should be scoped for unique, but our Postgres version cannot
  # select distinct on tables with JSON data types.
  has_many :developments, through: :development_team_memberships 
  belongs_to :creator,      class_name: :User

  validates :name,       presence: true
  validates :website,    presence: true
  validates :short_name, presence: true

  validates :creator, presence: true
  validate  :valid_email, if: 'email.present?'
  validate  :valid_url_template, if: 'url_template.present?'

  def active_members
    memberships.where(state: 'active').map(&:user).uniq
  end

  def url_parser
    URITemplate.new(url_template)
  end

  def has_url_template?
    url_template.present?
  end

  def logo
    user = %w(mark lena lindsay molly eve).sample
    "http://semantic-ui.com/images/avatar2/small/#{user}.png"
  end

  def developments
    DevelopmentTeamMembership.where(organization_id: id)
      .includes(:development)
      .map(&:development)
      .uniq
  end

  # validates :existence_of_website
  private

    def valid_email
      addr = Mail::Address.new(email)
      throw StandardError if [addr.local, addr.domain].include?(nil)
    rescue
      errors.add(:email, "must be a valid email address")
    end

    def valid_url_template
      template = URITemplate.new(url_template.to_s)
      url_variables = template.tokens.map(&:variables).flatten
      if url_variables.exclude? "id"
        errors.add(:url_template, "must include '{id}' somewhere")
      end
    end
end
