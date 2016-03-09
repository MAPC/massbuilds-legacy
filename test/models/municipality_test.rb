require 'test_helper'

class MunicipalityTest < ActiveSupport::TestCase

  def municipality
    @_muni ||= places(:boston)
  end

  alias_method :muni, :municipality

  test 'valid?' do
    assert muni.valid?
  end

  test 'requires a name' do
    muni.name = ' '
    refute muni.valid?
  end

  test 'has neighborhoods' do
    assert_respond_to muni, :neighborhoods
    refute_empty muni.neighborhoods
  end

  test 'geometry' do
    skip 'Add geometry'
  end

  test 'crosswalks / muni id' do
    skip 'Add a way to have muni_id crosswalk'
  end
end
