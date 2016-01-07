class Search < ActiveRecord::Base
  belongs_to :user

  def developments
    DevelopmentSearch.new(self.query).result
  end
end
