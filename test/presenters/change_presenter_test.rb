require 'test_helper'

class ChangePresenterTest < ActiveSupport::TestCase

  def presenter
    @_presenter ||= ChangePresenter.new(field_edits(:one))
  end

  def item
    presenter.item
  end

  alias_method :pres, :presenter

  test 'numbers' do
    item.change = { from: 100.0, to: 200 }
    assert_equal 'changed Commercial Square Feet from 100.0 to 200.0', pres.text
    item.change = { from: 200, to: nil }
    assert_equal 'changed Commercial Square Feet from 200 to 0', pres.text
    item.change = { from: nil, to: 200 }
    assert_equal 'changed Commercial Square Feet from 0 to 200', pres.text
  end

  test 'booleans' do
    item.change = { from: true, to: false }
    assert_equal 'set Commercial Square Feet to false', pres.text
    item.change = { from: false, to: true }
    assert_equal 'set Commercial Square Feet to true', pres.text
    item.change = { from: nil, to: true }
    assert_equal 'set Commercial Square Feet to true', pres.text
    item.change = { from: true, to: nil }
    assert_equal 'set Commercial Square Feet to false', pres.text
  end

  test 'strings' do
    item.change = { from: 'Godfrey', to: 'The Godfrey.' }
    expect = "changed Commercial Square Feet from 'Godfrey' to 'The Godfrey.'"
    assert_equal expect, pres.text
  end

  test 'unexpected' do
    item.change = { from: Class, to: Object }
    assert_raises(ArgumentError) { pres.text }
  end

  test 'changeable attributes have human names' do
    development = developments(:one)
    attributes = development.attributes.select { |_k, v| !v.is_a? String }
    deletable_attributes.each { |key| attributes.delete(key) }
    attributes.each_pair do |key, _v|
      expected = key.to_s.titleize
      actual = Development.human_attribute_name(key)
      refute_equal expected, actual
    end
  end

  private

  def deletable_attributes
    %w( id   state   creator_id fields  phased   status stalled   parcel_id
        city stories total_cost private latitude height longitude place_id
        walkscore point
      )
  end

end
