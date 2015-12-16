require 'test_helper'

class UserPresenterTest < ActiveSupport::TestCase
  def presenter
    @_presenter ||= UserPresenter.new(users(:lower_case))
  end
  def item
    presenter.item
  end
  alias_method :pres, :presenter

  test "first name and last name" do
    assert_equal 'Matt',  pres.first_name
    assert_equal 'Gardner', pres.last_name
  end

  test "short name" do
    assert_equal 'Matt G.', pres.short_name
  end

  test "full_name" do
    assert_equal 'Matt Gardner', pres.full_name
  end
  
  test "gravatar id" do
    assert_equal '4b258e95d8f90023e4499a077ec4ab83', pres.gravatar_id
  end

  test "gravatar url" do
    assert_equal 'https://secure.gravatar.com/avatar/4b258e95d8f90023e4499a077ec4ab83', pres.gravatar_url
  end
end