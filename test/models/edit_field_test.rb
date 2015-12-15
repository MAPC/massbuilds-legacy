require 'test_helper'

class EditFieldTest < ActiveSupport::TestCase
  def edit_field
    @_edit_field = edit_fields :one
  end
  alias_method :field, :edit_field

  test "valid" do
    assert field.valid?, field.errors.full_messages
  end

  test "requires a name" do
    field.name = nil
    assert_not field.valid?
  end

  test "requires a name in Development attributes" do
    field.name = 'blerg'
    assert_not field.valid?
  end

  test "requires an edit" do
    field.edit = nil
    assert_not field.valid?
  end

  test "requires a change" do
    field.change = nil
    assert_not field.valid?
    field.change = {}
    assert_not field.valid?
  end

  test "requires a change that has, at least, :to" do
    field.change = {from: 100, to: 101}
    assert field.valid?
    field.change = {to: true}
    assert field.valid?
  end

  test "requires a change that is really a change" do
    field.change = {from: 100, to: 100}
    assert_not field.valid?
    field.change = {from: 100, to: 101}
    assert field.valid?
  end

  test "#from" do
    assert_equal 12, field.from
  end

  test "#to" do
    assert_equal 1000, field.to
  end
end
