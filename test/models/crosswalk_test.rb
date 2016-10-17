require 'test_helper'

class CrosswalkTest < ActiveSupport::TestCase
  def crosswalk
    @crosswalk ||= crosswalks :one_mapc
  end
  alias_method :walk, :crosswalk

  test 'valid' do
    skip
    assert crosswalk.valid?
  end

  test 'requires an organization' do
    skip
    crosswalk.organization = nil
    assert_not crosswalk.valid?
  end

  test 'requires an development' do
    skip
    crosswalk.development = nil
    assert_not crosswalk.valid?
  end

  test 'requires an internal ID' do
    skip
    crosswalk.internal_id = " "
    assert_not crosswalk.valid?
  end

  test 'generates a link if the organization has a template' do
    skip
    crosswalk.organization.url_template = "http://mapc.org/projects/{id}"
    expected = "http://mapc.org/projects/MAPC-1"
    assert_equal expected, crosswalk.url
  end

  test 'generates nil link otherwise' do
    skip
    assert_nil crosswalk.url
  end
end
