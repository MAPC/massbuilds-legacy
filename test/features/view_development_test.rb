require 'test_helper'

class ViewDevelopmentTest < Capybara::Rails::TestCase

  def development
    @_development ||= developments(:one)
  end

  def out_of_date
    Time.stub :current, Time.at(0) do
      development.update_attribute :updated_at, 7.months.ago
    end
    development.save!
    development
  end

  def setup
    visit development_path(development)
  end

  test 'content there' do
    assert_content page, development.name
  end

  test 'out of date' do
    visit development_path(out_of_date)
    assert_content page, 'Help keep this page up to date'
  end

end
