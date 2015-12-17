require "test_helper"

class PendingEditsTest < Capybara::Rails::TestCase

  def setup
    visit developments_path
    first('a.development').click
    assert_content page, 'Godfrey Hotel'
    click_link 'Moderate'
  end

  test "view pending edits" do
    ['Proposed changes to', 'Decline', 'Approve'].each {|content|
      assert_content page, content
    }
    assert_content 'changed commsf'
  end

  test "approve edit" do
    click_link 'Approve'
    save_and_open_page
    assert_content 'approved'
    refute_content 'Approve'
    refute_content 'Decline'
    refute_content 'changed commsf'
  end

  test "decline edit" do
    click_link 'Decline'
    save_and_open_page
    assert_content 'declined'
    refute_content 'Approve'
    refute_content 'Decline'
    refute_content 'changed commsf'
  end
end
