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
end
