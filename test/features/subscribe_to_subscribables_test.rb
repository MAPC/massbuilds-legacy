require 'test_helper'

class SubscribeToSubscribablesTest < Capybara::Rails::TestCase

  def user
    @_user ||= users :normal
    @_user.password = 'password'
    @_user
  end

  def development
    @_development ||= developments(:two)
  end

  def setup
    sign_in user, visit: true, submit: true
    visit development_path(development)
  end

  test 'without subscription' do
    skip
    assert_content page, 'Hello' # development name
    assert_content page, 'Watch'
  end

  test 'subscribe' do
    skip 'no subscribing'
    assert_content find('#watchers'), '0'
    click_button 'Watch'
    assert_content find('#watchers'), '1'
    # visit user page, see subscription
  end

end
