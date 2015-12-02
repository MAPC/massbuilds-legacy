require 'test_helper'

class InboxNoticeTest < ActiveSupport::TestCase
  def notification
    @notification ||= notifications :first
  end
  alias_method :notice, :notification

  test "valid" do
    skip
    assert notice.valid?
  end

  test "requires a level" do
    skip "One of: :info, :warn, :success, :danger"
  end

  test "requires a state" do
    skip "One of: :pending, :sent, :delivered, :unread, :read"
  end

  test "notifications" do
    skip "Notification event log, like NotificationEvent :sms, :number, :sent_at"
  end

  test "notified" do
    skip "If there are any notification events."
  end

  test "requires a subject line between 15 and 40 characters" do
    skip
    notice.subject = nil
    assert_not notice.valid?
    notice.subject = 'a' * 14
    assert_not notice.valid?
    notice.subject = 'a' * 41
    assert_not notice.valid?
  end

  test "requires a body between 15 and 140 characters" do
    skip
    notice.body = nil
    assert_not notice.valid?
    notice.body = " " * 14
    assert_not notice.valid?
    notice.body = 'a' * 14
    assert_not notice.valid?
    notice.body = 'a' * 141
    assert_not notice.valid?
  end

  test "when new, state :pending" do
    skip
    assert_equal :pending, Notice.new.state
  end

  test "when sent, state :sent" do
    skip
    notice.deliver_to(user)
    assert_equal :sent, notice.state
  end

  test "when read, state :read" do
    skip
    notice.read
    assert_equal :read, notice.state
  end
end
