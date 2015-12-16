require 'test_helper'

class ChangePresenterTest < ActiveSupport::TestCase
  def presenter
    @_presenter ||= ChangePresenter.new(edit_fields(:one))
  end
  def item
    presenter.item
  end
  alias_method :pres, :presenter

  # test "numbers" do
  #   item.change = {from: 100.0, to: 200}
  #   assert_equal "Changed commsf from 100.0 to 200.0", pres.text
  #   item.change = {from: 200, to: nil}
  #   assert_equal "Changed commsf from 200 to 0", pres.text
  #   item.change = {from: nil, to: 200}
  #   assert_equal "Changed commsf from 0 to 200", pres.text
  # end

  # test "booleans" do
  #   item.change = {from: true, to: false}
  #   assert_equal "Set commsf to false", pres.text
  #   item.change = {from: false, to: true}
  #   assert_equal "Set commsf to true", pres.text
  #   item.change = {from: nil, to: true}
  #   assert_equal "Set commsf to true", pres.text
  #   item.change = {from: true, to: nil}
  #   assert_equal "Set commsf to false", pres.text
  # end

end