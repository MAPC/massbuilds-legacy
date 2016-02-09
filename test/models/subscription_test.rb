require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  def subscription
    @_subscription ||= subscriptions(:one)
  end

  def subscription_two
    @_subscription_two ||= subscriptions(:two)
  end

  class BadThing < ActiveRecord::Base
    self.table_name = 'users'
  end

  class ValidSubscribable < BadThing
    def developments ; Array.new ; end
  end

  test 'valid?' do
    assert subscription.valid?
  end

  test 'requires a user' do
    subscription.user = nil
    refute subscription.valid?
  end

  test 'requires a subscribable' do
    subscription.subscribable = nil
    refute subscription.valid?
  end

  test 'subscribables must be a Development or respond to #developments' do
    subscription.subscribable = BadThing.new
    refute subscription.valid?
    subscription.subscribable = ValidSubscribable.new
    assert subscription.valid?
  end

  test 'subscribables can be Development' do
    [Development.new, Search.new, Place.new].each {|watch_me|
      subscription.subscribable = watch_me
    }
    assert subscription.valid?
  end

end
