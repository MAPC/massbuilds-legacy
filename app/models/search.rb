class Search < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true

  def results
    Development.periscope(query)
  end

  def unsaved?
    !saved?
  end
end
