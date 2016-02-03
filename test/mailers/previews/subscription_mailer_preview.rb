# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/digest
  def digest
    SubscriptionMailer.digest(User.first)
  end

end
