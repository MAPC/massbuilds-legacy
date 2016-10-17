require 'test_helper'

class NearestTransitTest < ActiveSupport::TestCase

  test 'nearest transit station' do
    d.latitude_will_change! # This prompts an update.
    d.save
    assert_respond_to d, :nearest_transit
    assert_equal d.nearest_transit, 'Boylston'
  end

end

