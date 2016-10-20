require 'test_helper'

class NearestTransitTest < ActiveSupport::TestCase

  include ExternalServices::Fakes

  def development
    @development ||= developments(:one)
    mock_out @development
  end

  test 'nearest transit station' do
    development.latitude_will_change! # This prompts an update.
    assert_respond_to development, :nearest_transit
    development.save
    assert_equal development.nearest_transit, 'Fake Station'
  end

end

