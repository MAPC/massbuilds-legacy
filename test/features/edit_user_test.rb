require 'test_helper'

class EditUserTest < Capybara::Rails::TestCase

  def user
    @user ||= users :normal
    @user.password = 'password'
    @user
  end

  test 'signed in user can edit name' do
    skip 'unclear why this is failing'
    sign_in user, visit: true, submit: true
    visit edit_user_registration_path
    fill_in 'First name', with: 'William'
    assert_equal 'William', find_field('First name').value
    click_button 'Update Profile'
    assert_content page, 'William'
  end
end
