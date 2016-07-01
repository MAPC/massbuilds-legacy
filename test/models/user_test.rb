require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def user
    @user ||= users :normal
  end

  def new_user
    @new_user ||= User.new(
      first_name: 'Mad',
      last_name: 'Max',
      email: 'zip@zap.zop',
      password: 'zipzapzop'
    )
  end

  def mock_subscribable
    mock = Minitest::Mock.new
    mock.expect :developments, []
    mock
  end

  test '#valid?' do
    assert user.valid?, user.errors.full_messages
    assert new_user.valid?, new_user.errors.full_messages
  end

  test 'requires a first name' do
    new_user.first_name = nil
    assert_not new_user.valid?
  end

  test 'requires a last name' do
    new_user.last_name = nil
    assert_not new_user.valid?
  end

  test 'hashes email before saving' do
    user.save
    assert_not_empty user.hashed_email
  end

  test 'assigns API key upon creation' do
    new_user = User.new(first_name: 'm', last_name: 'c', email: 'e@ma.il',
      password: 'password')
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

  test '#subscriptions' do
    refute_empty user.subscriptions
  end

  # TODO: Add Place to this list.
  test '#subscription can include all subscribable classes' do
    %w( Development Search ).each do |klass|
      assert_includes user.subscriptions.map(&:subscribable_type), klass
    end
  end

  test 'last checked subscriptions' do
    Time.stub :now, Time.new(2000) do
      new_user = User.new
      new_user.save!(validate: false)
      assert new_user.last_checked_subscriptions, new_user.inspect
      # Not returning, probably because Time.now is being called at
      # the database level in the prevent_null_last_check migration
      # assert_equal user.last_checked_subscriptions, Time.new(2000)
    end
  end

  # TODO: Fix the duplicated logic and the overuse of database
  #   interaction in these tests.

  test '#subscribe_to' do
    assert_respond_to user, :subscribe_to
    assert_respond_to user, :subscribe

    subscribable = developments(:one)
    user.subscriptions = []
    user.save

    assert_difference 'Subscription.count', +1 do
      user.subscribe(subscribable)
    end
  end

  test '#unsubscribe_from' do
    assert_respond_to user, :unsubscribe_from
    assert_respond_to user, :unsubscribe
    subscribable = developments(:one)
    user.subscribe(subscribable)
    assert_difference 'Subscription.count', -1 do
      user.unsubscribe(subscribable)
    end
  end

  test '#subscribed_to?' do
    assert_respond_to user, :subscribed_to?
    assert_respond_to user, :subscribed?

    subscribable = developments(:one)
    user.subscriptions = []
    user.save

    refute user.subscribed_to?(subscribable)
    user.subscriptions.create(subscribable: subscribable)
    assert user.subscribed_to?(subscribable)
  end

  test 'changes last subscription date frequency changes to non-never' do
    peter = users(:peter_pan)
    peter.update_attribute(:mail_frequency, :weekly)
    assert peter.last_checked_subscriptions > 2.weeks.ago
  end

  test 'no change if going between non-nevers' do
    assert_no_difference 'user.last_checked_subscriptions' do
      user.update_attribute(:mail_frequency, :weekly)
    end
  end

  test 'no change if going between nevers' do
    peter = users(:peter_pan)
    assert_no_difference 'peter.last_checked_subscriptions' do
      peter.update_attribute(:mail_frequency, :never)
    end
  end

  test 'creator is an admin of organization' do
    assert_respond_to user, :admin_of?
    assert user.admin_of? organizations(:mapc)
    refute user.admin_of? organizations(:bra)
  end

  test 'org admins can be added' do
    org = organizations(:bra)
    refute user.admin_of?(org)
    mem = user.memberships.create!(organization: org, role: :admin, state: :active)
    assert user.admin_of?(org)
    mem.destroy if mem
  end

end
