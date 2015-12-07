class Organization < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :administrators, class_name: :User
  belongs_to :creator,      class_name: :User

  validates :name,       presence: true
  validates :website,    presence: true
  validates :short_name, presence: true

  validates :creator, presence: true
  validate  :valid_email, if: 'email.present?'

  def active_members
    memberships.where(state: 'active').map(&:user)
  end

  # validates :existence_of_url
  private

    def valid_email
      addr = Mail::Address.new(email)
      throw StandardError if [addr.local, addr.domain].include?(nil)
    rescue
      errors.add(:email, "must be a valid email address")
    end
end
