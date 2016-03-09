require 'test_helper'

class DevelopmentTeamMembershipTest < ActiveSupport::TestCase
  def membership
    @membership ||= development_team_memberships :one
  end

  alias_method :m, :membership

  test 'valid' do
    assert m.valid?
  end

  test 'requires an organization' do
    m.organization = nil
    assert_not m.valid?
  end

  test 'requires a development' do
    m.development = nil
    assert_not m.valid?
  end

  test 'response to a role' do
    assert_respond_to m, :role
  end

  test 'valid roles' do
    roles = [:developer, :architect, :engineer,
             :contractor, :landlord, :owner]
    roles.each do |role|
      m.role = role
      assert m.valid?
    end
  end

  test 'invalid roles' do
    m.role = "blerg"
    assert_not m.valid?
  end

  test 'role predicates' do
    roles = [:developer?, :architect?, :engineer?,
             :contractor?, :landlord?, :owner?]
    roles.each { |role| assert_respond_to m, role }
  end

  test 'role order' do
    roles = DevelopmentTeamMembership.role.values
    assert_equal 'developer', roles.first
    assert_equal 'designer', roles.last
  end

  test 'role order in database' do
    klass = DevelopmentTeamMembership

    klass.destroy_all
    klass.new(role: :owner).save(validate: false)
    klass.new(role: :architect).save(validate: false)

    first_role = klass.order(:role).first.role
    last_role  = klass.order(role: :desc).first.role
    assert_equal 'architect', first_role
    assert_equal 'owner', last_role
  end

  test 'requires a role' do
    m.role = nil
    assert_not m.valid?
  end

  test 'membership needs to be unique in terms of role' do
    dev = developments(:one)
    org = organizations(:mapc)
    role = :architect

    new_mem = DevelopmentTeamMembership.new(development: dev, organization: org, role: role)
    dupe = new_mem.dup

    new_mem.save!
    refute dupe.valid?
    dupe.role = :designer
    assert dupe.valid?, dupe.errors.full_messages
  end

end
