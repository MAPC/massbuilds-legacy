require "test_helper"

class EditOrganizationTest < Capybara::Rails::TestCase

  def user
    @user ||= users :normal
    @user.password = 'password'
    @user
  end

  def organization
    @organization ||= organizations :mapc
  end

  alias_method :org, :organization

  test "signed in user visits existing organization and requests to join it" do
    sign_in user, visit: true, submit: true
    visit organization_path(org)
    click_link 'Request to Join'
    assert_content page, 'Membership request sent'
  end

  test "signed in user visits existing organization, requests to join it twice, and receives an error the second time" do
    sign_in user, visit: true, submit: true
    visit organization_path(org)
    click_link 'Request to Join'
    click_link 'Request to Join'
    assert_content page, 'Organization has already been taken'
  end

  test "signed in user visits existing organization, requests to join it, and cancels join request" do
    sign_in user, visit: true, submit: true
    visit organization_path(org)
    click_link 'Request to Join'
    visit user_path(user)
    click_link 'Cancel'
    refute_content page, 'Metropolitan Area Planning Council'
  end
end
