class DigestJob

  attr_reader :frequency, :time

  # In case the scheduler runs a early, we have a buffer.
  BUFFER = 6.hours

  TIME_LOOKUP = {
    daily:  1.day.ago  + BUFFER,
    weekly: 1.week.ago + BUFFER,
    # To be more explicit and avoid checking, I don't want :never to
    # return nil, even though nil returns 0 users and is kind of useful.
    never:  Time.zone.now
  }.freeze

  def initialize(frequency = :weekly)
    @frequency = frequency
    assert_frequency_in_options
    @time = TIME_LOOKUP[frequency]
  end

  def perform
    users.find_each do |user|
      send_email_and_update(user)
    end
  end

  def users
    return [] if @frequency == :never
    User.where('last_checked_subscriptions < ?', @time).
      where(mail_frequency: @frequency)
  end

  private

  def send_email_and_update(user)
    if user.subscriptions_needing_update.any?
      SubscriptionMailer.digest(user).deliver_later
    end
    user.touch :last_checked_subscriptions
  rescue => e
    log_error(e, user)
  end

  def log_error(e, user)
    Rails.logger.error "Could not email user #{user}"
    Rails.logger.error "#{e.message}\n#{e.backtrace}"
  end

  def assert_frequency_in_options
    opts = User.mail_frequency.options.map { |o| o.last.to_sym }
    unless opts.include?(@frequency)
      raise ArgumentError, error_message
    end
  end

  def error_message
    "Frequency must be one of #{opts}, but was #{@frequency.inspect}"
  end

end
