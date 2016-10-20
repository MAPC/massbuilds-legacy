require 'test_helper'

class EditDevelopmentTest < Capybara::Rails::TestCase

  def user
    @user ||= users :normal
  end

  def development
    @development ||= developments :one
  end

  def setup
    visit signin_path
    sign_in user, password: default_password
    visit development_path(development)
  end

  test 'signed-in user sees the edit button' do
    assert_link "Propose a Change"
  end

  test 'signed-in user clicks the edit button and submits a form' do
    click_link "Propose a Change"
    assert_content "Editing Godfrey Hotel"
    fill_in 'Total housing units',    with: 10
    fill_in 'Commercial square feet', with: 500
    fill_in 'Estimated Employment',   with: 0
    select 'proposed', from: 'Completion Status'
    assert_difference 'Edit.count', +1 do
      assert_difference 'Field.count', +4 do
        click_link 'Submit'
      end
    end
    assert_content 'proposed changes'
  end

  test 'update street view' do
    skip 'how do we set fields?'
  end

end
