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

  test 'creator is an admin' do
    assert_equal org.creator, org.admin
  end

  test 'when created, builds a membership' do
    assert_difference 'Membership.count', +1 do
      Organization.new(creator: users(:tim)).save(validate: false)
    end
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
  end

  test 'can accept an abbreviation' do
    org.abbv = nil
    assert org.valid?
    org.abbv = 'NOTNIL'
    assert org.valid?
  end

  test 'does not require a URL' do
    org.website = nil
    assert org.valid?
  end

  test 'requires a URL that exists' do
    # Read https://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/
    # and http://stackoverflow.com/questions/5908017/check-if-url-exists-in-ruby
    skip
    org.website = 'https://lo.lllll'
    assert_not org.valid?
    org.website = 'http://homestarrunner.com'
    assert org.valid?
  end

  test 'has a log' do
    skip "
      Tracks when:
        - A member invites another member.
        - An invited member accepts.
        - A member leaves.
        - A member is kicked out.
    "
  end

  test 'can have many members through memberships' do
    org.memberships.create user: users(:normal)
    org.memberships.create user: users(:moderator)
    assert_not_empty org.members
  end

  test '#active_members' do
    org.memberships.create user: users(:normal)
    org.memberships.create user: users(:moderator), state: :active
    assert_equal 2, org.active_members.count # add one for the creator
    assert_includes org.active_members, users(:moderator)
  end

  test 'members can belong to many organizations' do
    user   = users :normal # Already a member of MAPC
    massit = organizations :massit
    assert massit.members << user
  end

  test 'URL template' do
    org.url_template = template('?project={id}')
    expanded = org.url_parser.expand(id: 45)
    expected = template('?project=45')
    assert_equal expanded, expected
  end

  test 'requires valid URL template' do
    org.url_template = template('?project=')
    assert_not org.valid?
  end

  test '#has_url_template?' do
    org.url_template = 'x'
    assert org.has_url_template?
    org.url_template = ' '
    assert_not org.has_url_template?
  end

  test 'crosswalks' do
    skip 'not there'
    dev = developments :one
    org.crosswalks.new(development: dev, internal_id: '1-0')
    assert_not_empty org.crosswalks
  end

  test 'related developments custom method responds correctly' do
    assert_respond_to(org, :developments)
  end

  test 'hashes an email before saving' do
    org.save!
    assert_not_empty org.hashed_email
  end

  test 'tries to hash gravatar_email, then other email' do
    org.email = 'base_email@example.com'
    org.gravatar_email = 'gravatar_email@example.com'
    base_hash = Digest::MD5.hexdigest(org.email.dup)
    grav_hash = Digest::MD5.hexdigest(org.gravatar_email.dup)
    org.save!
    assert_equal grav_hash, org.hashed_email
    org.gravatar_email = nil
    org.save!
    assert_equal base_hash, org.hashed_email
  end

  test 'municipal?' do
    assert_respond_to organization, :municipal
    assert_respond_to organization, :municipal?
    refute Organization.new.municipal?
  end

  private

  def webster
    "
      Lake Char­gogg­a­gogg­man­chaugg­a­gogg­chau­bun­a­gung­a­maugg
      / Webster Lake, Webster, Massachusetts, United States of America
    ".strip.gsub(/\s+/, ' ')
  end

  def template(part)
    "http://www.bostonredevelopmentauthority.org/document-center#{part}"
  end
end
