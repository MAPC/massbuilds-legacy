require 'test_helper'

class DevelopmentsSerializerTest < ActiveSupport::TestCase
  def serializer
    @_base ||= DevelopmentsSerializer.new(
      [developments(:one), developments(:two)]
    )
  end
  alias_method :base, :serializer

  test "#developments" do
    refute_empty base.developments
  end

  test "prevents empty developments" do
    assert_raises(ArgumentError) { DevelopmentsSerializer.new([]) }
  end

  test "#to_header" do
    assert_equal expected_header, base.to_header
  end

  test "#to_csv" do
    assert_respond_to base, :to_csv
    Time.stub :now, Time.at(0) do   # stub goes away once the block is done
      assert_equal expected_csv, base.to_csv
    end
  end

  test "#to_file" do
    skip
  end

  private

    def expected_csv
      csv = <<-CSV
id,creator_id,fields,created_at,updated_at,rdv,asofright,ovr55,clusteros,phased,stalled,name,status,desc,project_url,mapc_notes,tagline,address,city,state,zip_code,height,stories,year_compl,prjarea,singfamhu,twnhsmmult,lgmultifam,tothu,gqpop,rptdemp,emploss,estemp,commsf,hotelrms,onsitepark,total_cost,team_membership_count,team_member_1_name,team_member_1_website,team_member_1_url_template,team_member_1_location,team_member_1_email,team_member_1_abbv,team_member_1_short_name,team_member_1_role
980190962,562391268,{},1970-01-01 00:00:00 UTC,1970-01-01 00:00:00 UTC,,,,,,,Godfrey Hotel,,,,,,505 Washington Street,Boston,MA,02111,,,,,,,,,,,,75,12,,,,1,Metropolitan Area Planning Council,http://mapc.org,,\"Boston, MA\",,MAPC,MAPC,landlord
298486374,562391268,{},1970-01-01 00:00:00 UTC,1970-01-01 00:00:00 UTC,,,,,,,Hello,,,,,,It's me / I was wondering if after all the years,you'd like to me,ET,02118,,,,,,,,,,,,1000,200,,,,,,,,,,,,
      CSV
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
       "team_member_1_email", "team_member_1_abbv", "team_member_1_short_name",
       "team_member_1_role"]
    end
end
