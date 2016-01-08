require 'test_helper'

class CsvSerializerTest < ActiveSupport::TestCase
  def serializer
    @_base ||= CsvSerializer.new(nil)
  end

  def serializer_with_development
    @_development ||= CsvSerializer.new(developments(:one))
  end

  def serializer_only
    @_only ||= CsvSerializer.new(developments(:one), only: :name)
  end

  def serializer_except
    @_except ||= CsvSerializer.new(developments(:one), except: ['name', 'address'])
  end

  alias_method :base,   :serializer
  alias_method :dev,    :serializer_with_development
  alias_method :only,   :serializer_only
  alias_method :except, :serializer_except

  test "#to_row" do
    assert_respond_to base, :to_row
  end

  test "#to_row produces csv row of values" do
    # Because the Time.zone.now.to_s might be a second off from the
    # result, we check to see if the difference has two elements (the
    # two time fields) or none (they're the same.)
    count = (expected_row - dev.to_row).count
    assert [0,2].include?(count)
  end

  test "#to_header with an #attribute-less object" do
    assert_respond_to base, :to_header
    assert_equal [], base.to_header
  end

  test "#to_header with an object" do
    assert_equal expected_header, dev.to_header
  end

  test "can allow (only) certain attributes" do
    assert_equal ['Godfrey Hotel'], only.to_row
    assert_equal ['name'], only.to_header
  end

  test "can block (except) attributes" do
    refute_includes except.to_row, 'Godfrey Hotel'
    refute_includes except.to_row, '505 Washington Street'
    refute_includes except.to_header, 'name'
  end


  private

    def expected_row
      [980190962, 562391268, {}, Time.zone.now.to_s, Time.zone.now.to_s, nil, nil, nil, nil, nil, nil, "Godfrey Hotel", nil, nil, nil, nil, nil, "505 Washington Street", "Boston", "MA", "02111", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 75, 12, nil, nil, nil]
    end

    def expected_header
      ["id", "creator_id", "fields", "created_at", "updated_at", "rdv", "asofright", "ovr55", "clusteros", "phased", "stalled", "name", "status", "desc", "project_url", "mapc_notes", "tagline", "address", "city", "state", "zip_code", "height", "stories", "year_compl", "prjarea", "singfamhu", "twnhsmmult", "lgmultifam", "tothu", "gqpop", "rptdemp", "emploss", "estemp", "commsf", "hotelrms", "onsitepark", "total_cost"]
    end

end
