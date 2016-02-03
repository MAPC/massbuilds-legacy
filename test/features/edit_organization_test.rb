require 'test_helper'

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

  test 'signed in user visits existing organization, and successfully edits it' do
    sign_in user, visit: true, submit: true
    visit edit_organization_path(org)
    fill_in 'organization_name', :with => 'Boston Properties'
    fill_in 'organization_email', :with => 'brauser@bra.org'
    fill_in 'organization_location', :with => 'brauser@bra.org'
    fill_in 'organization_short_name', :with => 'BRA'
    fill_in 'organization_website', :with => 'bra.org'
    click_button 'Submit'
    assert_content page, 'Boston Properties'
  end
end
