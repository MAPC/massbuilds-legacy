require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def user
    @user ||= users :normal
  end

  test "requires a first name" do
    user.first_name = nil
    assert_not user.valid?
  end

  test "requires a last name" do
    user.last_name = nil
    assert_not user.valid?
  end

  test "hasherize email" do
    user.save
    assert_not_empty user.hashed_email
  end
end
