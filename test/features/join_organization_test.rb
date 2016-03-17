require 'test_helper'

class JoinOrganizationTest < Capybara::Rails::TestCase

  def user
    @user ||= users :normal
    @user.password = 'password'
    @user
  end

  def organization
    @organization ||= organizations :mapc
  end

  alias_method :org, :organization

  test 'signed in user requests to join organization' do
    sign_in user, visit: true, submit: true
    visit organization_path(org)
    click_link 'Request'
    assert_content page, 'Membership request sent'
  end

  test 'signed in user requests to join org twice and receives an error the second time' do
    sign_in user, visit: true, submit: true
    visit organization_path(org)
    2.times { click_link 'Request' }
    assert_content page, 'already requested'
  end

  test 'signed in user requests to join organization and cancels join request' do
    sign_in user, visit: true, submit: true
    visit organization_path(org)
    click_link 'Request'
    visit user_path(user)
    click_link 'Cancel'
    refute_content page, 'Metropolitan Area Planning Council'
  end
end
