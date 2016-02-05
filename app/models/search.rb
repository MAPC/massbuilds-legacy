class Search < ActiveRecord::Base
  belongs_to :user

  before_save :ensure_title

  validates :user, presence: true

  def results
    Development.periscope( Array(query) )
  end

  def unsaved?
    !saved?
  end

  private

    def ensure_title
      return if (title || unsaved?)
      self.title = "Saved Search #{next_search_count(user)}"
    end

    def next_search_count(user)
      user.searches.where(saved: true).count + 1
    end
end
