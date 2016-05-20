require 'test_helper'

class ViewDevelopmentTest < Capybara::Rails::TestCase

  # def user
  #   @_user ||= users :normal
  #   @_user.password = 'password'
  #   @_user
  # end

  def development
    @_development ||= developments(:one)
  end

  def out_of_date
    development.updated_at = 7.months.ago
    development.save!
    development
  end

  def setup
    # sign_in user, visit: true, submit: true
    visit development_path(development)
  end

  test 'content there' do
    assert_content page, development.name
  end

  test 'out of date' do
    refute_content page, 'out of date'
    visit development_path(out_of_date)
    assert_content page, 'out of date'
  end

end
