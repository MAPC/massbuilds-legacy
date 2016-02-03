require 'test_helper'

class SubscriptionMailerTest < ActionMailer::TestCase

  def user
    @_user ||= users(:normal)
  end

  test "digest" do
    Date.stub :yesterday, Date.new(1970, 1, 1) do
      mail = SubscriptionMailer.digest(user).deliver_now
      assert_not ActionMailer::Base.deliveries.empty?
      assert_equal "Development Updates for Thursday, 1 Jan 1970", mail.subject
      assert_equal ["mcloyd@mapc.org"], mail.to
      assert_equal ["no-reply@dd.mapc.org"], mail.from
      # assert_equal read_fixture('digest').join, mail.text_part.body.to_s
      assert_equal read_fixture('digest.html').join, mail.html_part.body.to_s
    end

  end

end
