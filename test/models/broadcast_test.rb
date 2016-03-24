require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase
  # Everyone gets the same notification,
  # or same general notification with custom variables.
  def broadcast
    @broadcast ||= broadcasts :new_feature
  end
  alias_method :cast, :broadcast

  test 'valid' do
    assert cast.valid?
  end

  # Requires same fields as Notification / InboxMessage
  test 'requires a subject line' do
    cast.subject = nil
    assert_not cast.valid?
  end

  test 'requires a body' do
    cast.subject = nil
    assert_not cast.valid?
  end

  test 'requires a scheduled time when scheduling' do
    cast.scheduled_for = nil
    assert_raises(StandardError) { cast.schedule! }
  end

  test 'does not require a scope to save' do
    # is there a Rails query building GUI engine?
    # or are we just doing SQL inside a "where" bucket?
    cast.scope = 'manager IS NOT NULL'
    assert cast.valid?
  end

  test 'original state is draft' do
    assert_equal 'draft', Broadcast.new.state
  end

  test 'requires a scope to schedule or deliver' do
    cast.scope = nil
    assert_raise { cast.schedule! }
    assert_raise { cast.deliver! }
  end

  test 'requires a date to schedule but not to deliver' do
    cast.scheduled_for = nil
    assert_raises(StandardError) { cast.schedule! }
    assert_nothing_raised { cast.deliver! }
  end

  test 'requires a scope that returns > 0 records' do
    cast.scope = 'id IS NULL'
    assert_not cast.deliverable?
    assert_not cast.schedulable?
  end

  test 'state predicates' do
    [:draft?, :scheduled?, :delivered?].each { |method|
      assert_respond_to cast, method
    }
  end

  test 'requires a scope that does not unscope' do
    # i.e. builds off of default scope
    # I don't think they can unscope if we're throwing this
    # in a where clause.
    skip
  end

  test 'calculates count of affected users' do
  end

  test 'deliver' do
    skip 'No mail yet.'
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      broadcast.deliver!
    end
    assert_equal 'delivered', broadcast.state
  end

  test '#schedule!' do
    # TODO: assert_no_difference in the background job queue count
    broadcast.scheduled_for = 10.days.from_now
    broadcast.schedule!
    assert_equal 'scheduled', broadcast.state
  end

  test 'cannot reschedule a delivered message' do
    skip 'Not yet implemented.'
  end
end
