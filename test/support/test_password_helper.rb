require "bcrypt"

module TestPasswordHelper
  def default_password_digest
    BCrypt::Password.create(default_password, cost: BCrypt::Engine::MIN_COST)
  end

  def default_password
    "password"
  end
end
