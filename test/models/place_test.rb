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
    new_place = Place.new
    assert_empty new_place.developments
    refute new_place.updated_since?
  end

  test '#updated_since? with developments' do
    skip 'at 2016-07-01 10:22:57 -0400'
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

  # test '#municipality if assigned a municipality' do
  #   muni = places(:boston)
  #   d.place = muni
  #   assert_equal muni, d.municipality
  # end

  # test '#municipality if assigned a neighborhood' do
  #   hood = places(:back_bay)
  #   d.place = hood
  #   assert_equal hood.municipality, d.municipality
  # end

  # test '#neighborhood if assigned a neighborhood' do
  #   hood = places(:back_bay)
  #   d.place = hood
  #   assert_equal hood, d.neighborhood
  # end

  # test '#neighborhood if assigned a municipality' do
  #   muni = places(:boston)
  #   d.place = muni
  #   assert_equal nil, d.neighborhood
  # end


end
