require 'test_helper'

class DevelopmentSerializerTest < ActiveSupport::TestCase
  def serializer
    @_base ||= DevelopmentSerializer.new(nil)
  end

  def serializer_with_development
    @_development ||= DevelopmentSerializer.new(developments(:one))
  end

  def serializer_only
    @_only ||= DevelopmentSerializer.new(developments(:one), only: :name)
  end

  def serializer_except
    @_except ||= DevelopmentSerializer.new(developments(:one), except: ['name', 'address'])
  end

  alias_method :base,   :serializer
  alias_method :dev,    :serializer_with_development
  alias_method :only,   :serializer_only
  alias_method :except, :serializer_except

  test "#to_row" do
    assert_respond_to base, :to_row
  end

  test "#to_row produces csv row of values" do
    Time.stub :now, Time.at(0) do
      assert_equal expected_row, dev.to_row
    end
  end

  test "#to_row includes development team" do
    assert_includes dev.to_row, "landlord"
  end

  test "#to_header with an #attribute-less object" do
    assert_respond_to base, :to_header
    assert_equal [], base.to_header
  end

  test "#to_header with an object" do
    assert_equal expected_header, dev.to_header
  end

  test "#to_header shows development team" do
    assert_includes dev.to_header, "team_member_1_name"
    assert_includes dev.to_header, "team_member_1_role"
  end

  test "can allow (only) certain attributes" do
    refute_includes ['505 Washington Street'], only.to_row
    refute_includes ['address'], only.to_header
  end

  test "can block (except) attributes" do
    refute_includes except.to_row, 'Godfrey Hotel'
    refute_includes except.to_row, '505 Washington Street'
    refute_includes except.to_header, 'name'
  end


  private

    def expected_row
      [980190962, 562391268, {}, "1970-01-01 00:00:00 UTC",
      "1970-01-01 00:00:00 UTC", nil, nil, nil, nil, nil, nil,
      "Godfrey Hotel", nil, nil, nil, nil, nil, "505 Washington Street",
      "Boston", "MA", "02111", nil, nil, nil, nil, nil, nil, nil, nil,
      nil, nil, nil, 75, 12, nil, nil, nil, nil,
      "Metropolitan Area Planning Council", "http://mapc.org", nil,
      "Boston, MA", nil, "MAPC", "MAPC", "landlord"]
    end

    def expected_header
      ["id", "creator_id", "fields", "created_at", "updated_at",
       "rdv", "asofright", "ovr55", "clusteros", "phased", "stalled",
       "name", "status", "desc", "project_url", "mapc_notes",
       "tagline", "address", "city", "state", "zip_code", "height",
       "stories", "year_compl", "prjarea", "singfamhu", "twnhsmmult",
       "lgmultifam", "tothu", "gqpop", "rptdemp", "emploss", "estemp",
       "commsf", "hotelrms", "onsitepark", "total_cost",
       "team_membership_count", "team_member_1_name", "team_member_1_website",
       "team_member_1_url_template", "team_member_1_location",
       "team_member_1_email", "team_member_1_abbv",
       "team_member_1_short_name", "team_member_1_role"]
    end

end
