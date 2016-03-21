class DigestJob

  attr_reader :frequency, :time

  # In case the scheduler runs a early, we have a buffer.
  BUFFER = 6.hours

  TIME_LOOKUP = {
    daily:  1.day.ago  + BUFFER,
    weekly: 1.week.ago + BUFFER,
    never:  Time.now # Don't want this to be nil, but even though nil returns 0 users
  }.freeze

  def initialize(frequency=:weekly)
    @frequency = frequency
    assert_frequency_in_options
    @time = TIME_LOOKUP[frequency]
  end

  def perform
    users.find_each { |user| send_email_and_update(user) }
  end

  def users
    return [] if @frequency == :never
    User.where(mail_frequency: frequency).
         where('last_checked_subscriptions < ?', @time)
  end

  private

  def send_email_and_update(user)
    SubscriptionMailer.digest(user).deliver_later
    user.touch :last_checked_subscriptions
  rescue => e
    log_error(e)
  end

  def log_error(e)
    Rails.logger.error "Could not email user #{user}"
    Rails.logger.error "#{e.message}\n#{e.backtrace}"
  end

  def assert_frequency_in_options
    opts = User.mail_frequency.options.map { |o| o.last.to_sym }
    unless opts.include?(@frequency)
      raise ArgumentError,
        "Frequency must be one of #{opts}, but was #{@frequency.inspect}"
    end
  end

end
