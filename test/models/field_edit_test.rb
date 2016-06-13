require 'test_helper'

class FieldEditTest < ActiveSupport::TestCase
  def field_edit
    @_field_edit = field_edits :one
  end
  alias_method :field, :field_edit

  test 'valid' do
    assert field.valid?, field.errors.full_messages
  end

  test 'requires a name' do
    field.name = nil
    assert_not field.valid?
  end

  test 'requires a name in Development attributes' do
    field.name = 'blerg'
    assert_not field.valid?
  end

  test 'requires an edit' do
    field.edit = nil
    assert_not field.valid?
  end

  test 'requires a change' do
    field.change = nil
    assert_not field.valid?
    field.change = {}
    assert_not field.valid?
  end

  test 'requires a change that has, at least, :to' do

    field.change = { from: 100, to: 101 }
    assert field.valid?
    field.change = { to: true }
    assert field.valid?
  end

  test 'change :to a non-nil false value' do
    field.change = { from: true, to: false }
    assert field.valid?
    field.change = { from: nil, to: false }
    assert field.valid?
    field.change = { from: false, to: nil }
    assert_not field.valid?
  end

  test 'change a string to an empty string' do
    skip 'Not yet sure what to do about this.'
    field.change = { from: 'x', to: '' }
    assert_not field.valid?
  end

  test 'requires a change that is really a change' do
    field.change = { from: 100, to: 100 }
    assert_not field.valid?
    field.change = { from: 100, to: 101 }
    assert field.valid?
  end

  test '#from' do
    assert_equal 0, field.from
  end

  test '#to' do
    assert_equal 1000, field.to
  end

  test '#development' do
    assert_respond_to field, :development
  end

  test '#conflict' do
    assert_nil field.conflict
    field.development.commsf = 13
    expected = { current: 13, from: 0 }
    assert_equal expected, field.conflict
  end

  test '#conflict?' do
    refute field.conflict?
    field.development.commsf = 13
    assert field.conflict?
  end
end
