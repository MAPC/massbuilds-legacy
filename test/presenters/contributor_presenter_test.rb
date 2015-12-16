require 'test_helper'

class ContributorPresenterTest < ActiveSupport::TestCase
  def presenter
    @_presenter ||= ContributorPresenter.new(users(:lower_case))
  end
  def item
    presenter.item
  end
  alias_method :pres, :presenter

  test "first name and last name" do
    assert_equal 'bell',  pres.first_name
    assert_equal 'hooks', pres.last_name
  end

  test "short name" do
    assert_equal 'bell h.', pres.short_name
  end

  test "full_name" do
    assert_equal 'bell hooks', pres.full_name
  end

end