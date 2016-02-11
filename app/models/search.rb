class Search < ActiveRecord::Base
  belongs_to :user
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions, source: :user

  validates :user, presence: true

  def results
    Development.periscope(query)
  end

  alias_method :developments, :results

  def name
    "Fake Search Name #{id}"
  end

  def unsaved?
    !saved?
  end

  def updated_since?(timestamp = Time.now)
    return false if developments.empty?
    developments.order(updated_at: :desc).first.updated_since?(timestamp)
  end

end
