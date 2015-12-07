require "test_helper"

class FlagDevelopmentTest < Capybara::Rails::TestCase
  test "sign in, visit development, and flag it" do
    visit developments_path
    first('.development > a').click
    assert_content page, 'Godfrey Hotel'
    click_link 'Flag'
    assert_content page, 'Flag: Godfrey Hotel'
  end
end
