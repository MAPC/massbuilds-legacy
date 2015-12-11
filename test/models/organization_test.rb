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

  test 'if email, requires it to be valid' do
    org.email = nil
    assert org.valid?
    org.email = 'mapc.org'
    assert_not org.valid?
    org.email = 'info@mapc.org'
    assert org.valid?
  end

  test 'location' do
    org.location = nil
    assert org.valid?
    org.location = 'BOS MA'
    assert org.valid?
    org.location = 'Boston, MA'
    assert org.valid?
    org.location = 'Lake Char­gogg­a­gogg­man­chaugg­a­gogg­chau­bun­a­gung­a­maugg / Webster Lake, Webster, Massachusetts, United States of America'
    assert org.valid?
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
    user = users(:normal)
    massit = organizations :massit
    assert org.members << user
    assert massit.members << user
  end

  test 'URL template' do
    org.url_template = "http://www.bostonredevelopmentauthority.org/document-center?project={id}"
    expanded = org.url_parser.expand(id: 45)
    expected = "http://www.bostonredevelopmentauthority.org/document-center?project=45"
    assert_equal expanded, expected
  end

  test 'requires valid URL template' do
    org.url_template = "http://www.bostonredevelopmentauthority.org/document-center?project="
    assert_not org.valid?
  end

  test '#has_url_template?' do
    org.url_template = 'x'
    assert org.has_url_template?
    org.url_template = ' '
    assert_not org.has_url_template?
  end

  test 'crosswalks' do
    dev = developments :one
    org.crosswalks.new(development: dev, internal_id: '1-0')
    assert_not_empty org.crosswalks
  end
end
