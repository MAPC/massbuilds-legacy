require "test_helper"

class EditUserTest < Capybara::Rails::TestCase

  def user
    @user ||= users :normal
    @user.password = 'password'
    @user
  end

  test "signed in user can edit their profile by changing their name" do
    sign_in user, visit: true, submit: true
    visit edit_user_registration_path
    fill_in 'user_first_name', :with => 'William'
    click_button 'Update'
    assert_content page, 'William'
  end
end
