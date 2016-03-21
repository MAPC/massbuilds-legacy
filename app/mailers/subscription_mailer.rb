class SubscriptionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.digest.subject
  #
  def digest(user)
    @digest = DigestPresenter.new(user)

    mail to: user.email, subject: subject
  end

  private

  def subject
    timestamp = @digest.user.last_checked_subscriptions.to_s(:subject)
    "Development updates since #{timestamp}"
  end

end
