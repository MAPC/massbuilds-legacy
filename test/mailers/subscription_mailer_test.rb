require 'test_helper'

class SubscriptionMailerTest < ActionMailer::TestCase

  def user
    @_user ||= users(:normal)
  end

  test 'digest' do
    Date.stub :yesterday, Date.new(1970, 1, 1) do
      mail = SubscriptionMailer.digest(user).deliver_now
      assert_not ActionMailer::Base.deliveries.empty?
      expected = 'Development updates since Friday, 12 Feb 2016'
      assert_equal expected, mail.subject
      assert_equal ['mcloyd@mapc.org'], mail.to
      assert_equal ['no-reply@dd.mapc.org'], mail.from
    end
  end

end
