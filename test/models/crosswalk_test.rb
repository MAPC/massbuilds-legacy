require 'test_helper'

class CrosswalkTest < ActiveSupport::TestCase
  def crosswalk
    @crosswalk ||= crosswalks :one_mapc
  end
  alias_method :walk, :crosswalk

  test 'valid' do
    assert crosswalk.valid?
  end

  test 'requires an organization' do
    crosswalk.organization = nil
    assert_not crosswalk.valid?
  end

  test 'requires an development' do
    crosswalk.development = nil
    assert_not crosswalk.valid?
  end

  test 'requires an internal ID' do
    crosswalk.internal_id = " "
    assert_not crosswalk.valid?
  end

  test 'generates a link if the organization has a template' do
    crosswalk.organization.url_template = "http://mapc.org/projects/{id}"
    expected = "http://mapc.org/projects/MAPC-1"
    assert_equal expected, crosswalk.url
  end

  test 'generates nil link otherwise' do
    assert_nil crosswalk.url
  end
end
