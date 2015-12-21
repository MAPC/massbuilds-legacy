require 'test_helper'

class ChangePresenterTest < ActiveSupport::TestCase
  def presenter
    @_presenter ||= ChangePresenter.new(edit_fields(:one))
  end
  def item
    presenter.item
  end
  alias_method :pres, :presenter

  test "numbers" do
    item.change = {from: 100.0, to: 200}
    assert_equal "changed commsf from 100.0 to 200.0", pres.text
    item.change = {from: 200, to: nil}
    assert_equal "changed commsf from 200 to 0", pres.text
    item.change = {from: nil, to: 200}
    assert_equal "changed commsf from 0 to 200", pres.text
  end

  test "booleans" do
    item.change = {from: true, to: false}
    assert_equal "set commsf to false", pres.text
    item.change = {from: false, to: true}
    assert_equal "set commsf to true", pres.text
    item.change = {from: nil, to: true}
    assert_equal "set commsf to true", pres.text
    item.change = {from: true, to: nil}
    assert_equal "set commsf to false", pres.text
  end

  test "strings" do
    item.change = {from: "Godfrey", to: "The Godfrey."}
    assert_equal "changed commsf from 'Godfrey' to 'The Godfrey.'", pres.text
  end

  test "unexpected" do
    item.change = {from: Class, to: Object}
    assert_raises(ArgumentError) { pres.text }
  end

end