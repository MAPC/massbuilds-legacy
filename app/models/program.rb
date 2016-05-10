class Program < ActiveRecord::Base
  extend Enumerize
  self.inheritance_column = nil

  validates :name, presence: true
  validates :description, presence: true
  validates :type, presence: true

  enumerize :type, in: { regulatory: 1, incentive: 2 }, predicates: true

  default_scope { order(:type).order(:sort_order) }

  def self.incentive
    where type: :incentive
  end

  def self.regulatory
    where type: :regulatory
  end
end
