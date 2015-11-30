require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def organization
    @organization ||= organizations :mapc
  end
  alias_method :org, :organization

  test 'valid' do
    assert org.valid?, org.errors.full_messages
  end

  test 'requires a creator' do
    org.creator = nil
    assert_not org.valid?
  end

  test 'requires a name' do
    org.name = nil
    assert_not org.valid?
  end

  test 'requires a short name' do
    org.short_name = nil
    assert_not org.valid?
  end

  test 'can accept an abbreviation' do
    org.abbv = nil
    assert org.valid?
    org.abbv = 'NOTNIL'
    assert org.valid?
  end

  test 'requires a URL' do
    org.website = nil
    assert_not org.valid?
  end

  test 'requires a URL that exists' do
    skip """
      Read https://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/
      and http://stackoverflow.com/questions/5908017/check-if-url-exists-in-ruby
    """
    org.website = 'https://lo.lllll'
    assert_not org.valid?
    org.website = 'http://homestarrunner.com'
    assert org.valid?
  end

  test 'has a log' do
    skip """
      Tracks when:
        - A member invites another member.
        - An invited member accepts.
        - A member leaves.
        - A member is kicked out.
    """
  end

  test "can have many members" do
    assert org.members << users(:normal)
    assert org.members << users(:moderator)
  end

  test "members can belong to many organizations" do
    skip "Not the current database setup."
  end

  test "only administrators can promote members" do
    skip "Roles not yet implemented"
  end

  test "member can leave an organization" do
    skip
  end

  test "administrators are notified when someone leaves the org" do
    skip "Roles and notifications not yet implemented"
  end

  test "administrators are notified when someone wants in" do
    skip "email, notification / inbox"
  end
end
