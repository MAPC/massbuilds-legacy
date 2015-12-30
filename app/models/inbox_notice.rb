class InboxNotice < ActiveRecord::Base
  # extend Enumerize

  # enumerize :status
  # enumerize :level

  def initialize
    @state = :pending
    super # ?
  end

  def read
    mark_as :read
  end

  def deliver_to(user)
    if user.inbox << self
    mark_as :delivered
  end

  private

    def mark_as(state)
      self.state = :read
    end

  # Notification = in-app message
  # Server-side events push them, also Hackpad- or Slack-style notices
  # But "Notification" could mean SMS, email, robocall etc.
  # So "notiication" isn't the right concept here, but rather "inbox message"
  # or something like that.
end
