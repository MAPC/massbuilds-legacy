require 'test_helper'

class PendingEditsTest < Capybara::Rails::TestCase

  def user
    @_user ||= users :normal
    @_user.password = 'password'
    @_user
  end

  def setup
    sign_in user, visit: true, submit: true
    visit development_path(developments(:one))
    assert_content page, 'Godfrey Hotel'
    click_link 'Moderate'
  end

  test 'view pending edits' do
    ['Proposed changes to', 'Decline', 'Approve'].each { |content|
      assert_content page, content
    }
    assert_content 'changed Commercial Square Feet'
  end

  test 'approve edit' do
    click_link 'Approve'
    assert_content 'approved' # in the flash
    refute_content 'changed Commercial Square Feet from 12 to 1000'
  end

  test 'decline edit' do
    click_link 'Decline'
    assert_content 'declined' # in the flash
    refute_content 'changed Commercial Square Feet from 12 to 1000'
  end
end
