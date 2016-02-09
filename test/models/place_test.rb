require 'test_helper'

class PlaceTest < ActiveSupport::TestCase

  def place
    @_place ||= places(:boston)
  end

  test '#developments' do
    assert_respond_to place, :developments
  end

  test '#updated_since?' do
    assert_respond_to place, :updated_since?
  end

  test '#updated_since? without developments' do
    assert_empty place.developments
    refute place.updated_since?
  end

  test '#updated_since? with developments' do
    development = developments(:one)
    place.developments << development
    edit = development.edits.first
    Time.stub :now, Time.new(2000) do
      edit.applied
      edit.save
    end
    refute_empty development.history
    assert place.updated_since?(Time.new(1999))
  end

end
