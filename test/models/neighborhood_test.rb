require 'test_helper'

class NeighborhoodTest < ActiveSupport::TestCase

  def neighborhood
    @_hood ||= places(:back_bay)
  end

  alias_method :hood, :neighborhood

  test 'valid?' do
    assert hood.valid?
  end

  test 'requires a name' do
    hood.name = ' '
    refute hood.valid?
  end

  test 'has a municipality' do
    assert_respond_to hood, :municipality
    assert hood.municipality
  end

end
