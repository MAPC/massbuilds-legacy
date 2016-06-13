require 'test_helper'

class ClaimDevelopmentTest < Capybara::Rails::TestCase

  def setup
    @user = users :normal
    @user.password = 'password'
  end

  test 'sign in, visit development, and claim it' do
    skip 'no claiming'
    sign_in @user, visit: true, submit: true
    visit developments_path
    first('a.development').click
    assert_content page, 'Godfrey Hotel'
    click_link 'Claim'
    assert_content page, 'Claiming Godfrey Hotel'
    select 'Developer', from: 'role'
    assert_difference 'Claim.count', +1 do
      click_button 'Claim'
    end
  end
end
