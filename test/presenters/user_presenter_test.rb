require 'test_helper'

class UserPresenterTest < ActiveSupport::TestCase

  def presenter
    @_presenter ||= UserPresenter.new(users(:lower_case))
  end

  def item
    presenter.item
  end

  alias_method :pres, :presenter

  test 'first name and last name' do
    assert_equal 'Matt',  pres.first_name
    assert_equal 'Gardner', pres.last_name
  end

  test 'short name' do
    assert_equal 'Matt G.', pres.short_name
  end

  test 'full_name' do
    assert_equal 'Matt Gardner', pres.full_name
  end

  test 'gravatar id' do
    pres.save
    expected = '72dedd9e525e529e37b724e8aba4997f'
    assert_equal expected, pres.hashed_email
  end

  test 'gravatar url' do
    pres.save
    expected = 'https://secure.gravatar.com/avatar/72dedd9e525e529e37b724e8aba4997f?s=120&d=identicon'
    assert_equal expected, pres.gravatar_url
  end
end
