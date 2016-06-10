class Search < ActiveRecord::Base

  before_save :ensure_title
  before_save :clean_query

  belongs_to :user
  has_many :subscriptions, as: :subscribable
  has_many :subscribers,   through: :subscriptions, source: :user

  validates :user, presence: true

  def results
    Development.periscope Array(query)
  end

  def self.saved
    where saved: true
  end

  def query
    read_attribute(:query).reject { |_k, v| v.nil? }
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

  # TODO Filter out at the resource level.
  def clean_query
    cleaned = query.dup
    rejectable_keys.each { |key| cleaned.delete(key) }
    self.query = cleaned
  end

  def next_search_count(user)
    user.searches.saved.count + 1
  end

  def rejectable_keys
    %w( page number size )
  end
end
