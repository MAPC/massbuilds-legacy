require 'test_helper'

class DigestJobTest < ActiveSupport::TestCase

  def weekly_job
    @_wj ||= DigestJob.new
  end

  alias_method :job, :weekly_job

  def daily_job
    @_dj ||= DigestJob.new(:daily)
  end

  def user
    @_u ||= users(:tim)
  end

  test 'default frequency weekly' do
    assert_equal :weekly, job.frequency
  end

  test 'daily job has daily frequency' do
    assert_equal :daily, daily_job.frequency
  end

  test 'not included in weekly users when checked just now' do
    user.update_attribute(:last_checked_subscriptions, Time.zone.now)
    user.update_attribute(:mail_frequency, :weekly)
    refute_includes weekly_job.users, user,
      "#{user.id} should not be in wk #{weekly_job.users.map(&:id)}"
  end

  test 'not included in daily users when checked just now' do
    skip 'come back to this'
    user.update_attribute(:last_checked_subscriptions, Time.zone.now)
    user.update_attribute(:mail_frequency, :daily)
    expected = daily_job.users
    refute_includes expected, user,
      "#{user.id} should not be in daily #{expected.map(&:id)}"
  end

  test 'included in weekly, with buffer' do
    user.update_attribute :mail_frequency, :weekly
    user.update_attribute :last_checked_subscriptions,
      1.week.ago + 4.hours
    assert_includes weekly_job.users, user
  end

  test 'included in daily, with buffer' do
    user.update_attribute :mail_frequency, :daily
    user.update_attribute :last_checked_subscriptions, 20.hours.ago
    assert_includes daily_job.users, user
  end

  test 'never job can never perform' do
    user.update_attribute :mail_frequency, :never
    user.update_attribute :last_checked_subscriptions, 20.hours.ago
    refute_includes DigestJob.new(:never).users, user
  end

  test 'raises when wrong frequency' do
    assert_raises { DigestJob.new(:milennially) }
  end

end
