require 'test_helper'

class FlagDevelopmentTest < Capybara::Rails::TestCase

  def setup
    @user = users :normal
    @user.password = 'password'
  end

  test 'sign in, visit development, and flag it' do
    sign_in @user, visit: true, submit: true
    visit development_path(developments(:one))
    assert_content page, 'Godfrey Hotel'
    click_link 'Flag'
    assert_content page, 'Flagging Godfrey Hotel'
    fill_in 'Reason', with: 'a' * 140
    assert_difference 'Flag.count', +1 do
      click_button 'Flag'
    end
  end
end
