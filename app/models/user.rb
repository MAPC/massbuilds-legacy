class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Authority::UserAbilities
  extend Enumerize

  before_save :hash_email
  before_save :ensure_reasonable_last_checked
  before_create :set_initial_last_checked
  after_create :assign_api_key

  attr_readonly :api_key

  has_one  :api_key, dependent: :destroy
  has_many :searches, -> { where(saved: true) }
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  has_many :subscriptions

  validates :first_name, presence: true
  validates :last_name,  presence: true

  enumerize :mail_frequency, in: [:never, :daily, :weekly],
    predicates: true, default: :weekly

  def contributions
    Edit.where(editor_id: id, state: 'applied')
  end

  def member_of?(organization)
    organizations.include? organization
  end

  def subscribe(subscribable)
    subscriptions.create(subscribable: subscribable)
  end

  def unsubscribe(subscribable)
    subscriptions.where(subscribable: subscribable).first.destroy
  end

  def subscribed?(subscribable)
    subscriptions.where(subscribable: subscribable).present?
  end

  alias_method :subscribe_to, :subscribe
  alias_method :unsubscribe_from, :unsubscribe
  alias_method :subscribed_to?, :subscribed?

  def subscriptions_needing_update
    Subscription.where(id: subscriptions.select(&:needs_update?).map(&:id))
  end

  def known?
    !anonymous?
  end

  def anonymous?
    self == User.null
  end

  def self.null
    @null ||= new(email: '<Null User>')
  end

  private

  def hash_email
    self.hashed_email = Digest::MD5.hexdigest(email.downcase)
  end

  def ensure_reasonable_last_checked
    if mail_frequency_change && mail_frequency_change.last != 'never'
      self.last_checked_subscriptions = 1.week.ago
    end
  end

  def set_initial_last_checked
    self.last_checked_subscriptions = created_at
  end

  def assign_api_key
    APIKey.create!(user: self)
  end
end
