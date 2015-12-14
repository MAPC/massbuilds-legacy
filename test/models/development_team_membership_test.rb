require 'test_helper'

class DevelopmentTeamMembershipTest < ActiveSupport::TestCase
  def membership
    @membership ||= development_team_memberships :one
  end

  alias_method :m, :membership

  test "valid" do
    assert m.valid?
  end

  test "requires an organization" do
    m.organization = nil
    assert_not m.valid?
  end

  test "requires a development" do
    m.development = nil
    assert_not m.valid?
  end

  test "response to a role" do
    assert_respond_to m, :role
  end

  test "valid roles" do
    roles = [:developer, :architect, :engineer,
             :contractor, :landlord, :owner]
    roles.each do |role|
      m.role = role
      assert m.valid?
    end
  end

  test "invalid roles" do
    m.role = "blerg"
    assert_not m.valid?
  end

  test "role predicates" do
    roles = [:developer?, :architect?, :engineer?,
             :contractor?, :landlord?, :owner?]
    roles.each { |role| assert_respond_to m, role }
  end

  test "role order" do
    skip
  end

  test "requires a role" do
    m.role = nil
    assert_not m.valid?
  end

end
