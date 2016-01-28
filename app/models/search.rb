class Search < ActiveRecord::Base
  belongs_to :user

  def results
    Development.periscope(query)
  end

  def unsaved?
    !saved?
  end
end
