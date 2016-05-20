require 'test_helper'

class CreateOrganizationTest < Capybara::Rails::TestCase

  def organization
    @organization ||= organizations :mapc
  end
  alias_method :org, :organization

  def user
    @user ||= users :normal
    @user.password = 'password'
    @user
  end

  def unauthorized_user
    @unauthorized_user ||= users :lower_case
    @unauthorized_user.password = 'drowssap'
    @unauthorized_user
  end

  def fill_in_form
    fill_in :organization_name,       with: 'Boston Properties'
    fill_in :organization_email,      with: 'brauser@bra.org'
    fill_in :organization_location,   with: 'brauser@bra.org'
    fill_in :organization_short_name, with: 'BRA'
    fill_in :organization_website,    with: 'bra.org'
    click_button 'Submit'
  end

  test 'signed out guest, visit organization creation, and be redirected' do
    visit new_organization_path
    assert_content page, /sign|log in/
  end

  test 'visit organization creation, and not be redirected' do
    sign_in user, visit: true, submit: true
    visit new_organization_path
    assert_content page, /new organization/
  end

  test 'visits new organization path, and successfully creates organization' do
    sign_in user, visit: true, submit: true
    visit new_organization_path
    fill_in_form
    assert_content page, 'Boston Properties'
  end

  test 'visits existing organization, and successfully edits it' do
    sign_in user, visit: true, submit: true
    visit edit_organization_path(org)
    fill_in_form
    assert_content page, 'Boston Properties'
  end

  # test 'signed in user can only edit organizations she has permission to edit' do
  #   sign_in @unauthorized_user, visit: true, submit: true
  #   visit edit_organization_path(org)
  #   fill_in 'organization_name', :with => 'Boston Properties'
  #   fill_in 'organization_email', :with => 'brauser@bra.org'
  #   fill_in 'organization_location', :with => 'brauser@bra.org'
  #   fill_in 'organization_short_name', :with => 'BRA'
  #   fill_in 'organization_website', :with => 'bra.org'
  #   click_button 'Edit Organization'
  #   assert_content page, 'Access Denied'
  # end
end
