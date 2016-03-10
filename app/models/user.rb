class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :hash_email
  after_create :assign_api_key

  attr_readonly :api_key

  has_one  :api_key,       dependent: :destroy
  has_many :searches, -> { where(saved: true) }
  has_many :memberships
  has_many :organizations, through: :memberships

  has_many :subscriptions

  validates :first_name, presence: true
  validates :last_name,  presence: true

  def contributions
    Edit.where(editor_id: id, state: 'applied')
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

  def self.null
    @null ||= new(email: '<Null User>')
  end

  private

  def hash_email
    self.hashed_email = Digest::MD5::hexdigest(email.downcase)
  end

  def assign_api_key
    APIKey.create!(user: self)
  end
end
