require 'test_helper'

class DigestPresenterTest < ActiveSupport::TestCase

  def user
    @_user ||= users(:digestible)
  end

  def presenter
    @_presenter ||= DigestPresenter.new(user)
  end

  def item
    presenter.item
  end

  alias_method :pres, :presenter

  test '#user' do
    skip
    assert_respond_to pres, :user
    assert_equal item, pres.user
    assert user.last_checked_subscriptions < Time.at(0)
  end

  test '#subscriptions' do
    skip
    assert_respond_to pres, :subscriptions
    assert_equal pres.subscriptions, item.subscriptions_needing_update
  end

  test '#searches' do
    skip
    assert_respond_to pres, :searches
    assert_equal 1, pres.searches.count # Only returns saved searches
  end

  test '#places' do
    skip
    assert_respond_to pres, :places
  end

  test '#developments' do
    skip
    assert_respond_to pres, :developments
    expected = item.subscriptions_needing_update.count
    actual   = pres.developments.count

    assert_equal expected, actual
    assert_equal 2, actual
  end

  test '#unique_developments' do
    skip 'Should return developments not in searches, places'
  end

  test 'user_last_checked' do
    skip
    assert_equal user.last_checked_subscriptions, pres.user_last_checked
  end

end
