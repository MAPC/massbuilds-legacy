class APIKey < ActiveRecord::Base
  before_create :generate_token

  belongs_to :user

  attr_readonly :token

  validates :user,  presence: true

  private

  def generate_token
    begin
      self.token = SecureRandom.hex.to_s
    end while self.class.exists?(token: token)
  end

end
