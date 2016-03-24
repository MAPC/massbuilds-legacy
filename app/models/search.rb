class Search < ActiveRecord::Base
  belongs_to :user
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions, source: :user,
    dependent: :nullify

  before_save :ensure_title

  validates :user, presence: true

  def results
    Development.periscope(Array(query))
  end

  alias_method :developments, :results
  alias_attribute :name, :title

  def unsaved?
    !saved?
  end

  def updated_since?(timestamp = Time.now)
    return false if developments.empty?
    developments.order(updated_at: :desc).first.updated_since?(timestamp)
  end

  private

  def ensure_title
    return if title || unsaved?
    self.title = "Saved Search #{next_search_count(user)}"
  end

  def next_search_count(user)
    user.searches.where(saved: true).count + 1
  end
end
