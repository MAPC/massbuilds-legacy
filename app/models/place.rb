class Place < ActiveRecord::Base
  has_many :developments, dependent: :restrict_with_error
  validates :name, presence: true, length: { maximum: 65 }

  def updated_since?(timestamp = Time.now)
    return false if developments.empty?
    developments.order(updated_at: :desc).first.updated_since?(timestamp)
  end
end
