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

  test "hashes email before saving" do
    user.save
    assert_not_empty user.hashed_email
  end

  test "assigns API key upon creation" do
    new_user = User.new(first_name: 'm', last_name: 'c', email: 'e@ma.il', password: 'password')
    refute new_user.api_key
    new_user.save!
    assert new_user.reload.api_key, user.inspect
  end

  test "cannot change user's API key once set" do
    [APIKey.new, nil].each do |value|
      assert_raises(ActiveRecord::ActiveRecordError) {
        user.update_attribute(:api_key, value)
      }
    end
  end

  test "can change user's API key before saving" do
    new_user = User.new
    new_user.api_key = APIKey.new
    assert new_user.api_key
  end

  test "#searches returns user's saved searches" do
    saved_search = searches(:saved)
    assert_equal user, saved_search.user
    assert_equal [saved_search.id], user.searches.map(&:id)
  end

end
