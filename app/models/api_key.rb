class APIKey < ActiveRecord::Base
  before_create :generate_token

  belongs_to :user

  attr_readonly :token

  validates :user,  presence: true

  def to_s
    token
  end

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.hex.to_s
      break random_token unless self.class.exists?(token: random_token)
    end
  end

end
