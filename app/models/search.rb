class Search < ActiveRecord::Base
  belongs_to :user
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions, source: :user

  validates :user, presence: true

  def results
    Development.periscope(query)
  end
  alias_method :developments, :results

  def unsaved?
    !saved?
  end
end
