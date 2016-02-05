require 'test_helper'

class DevelopmentsSerializerTest < ActiveSupport::TestCase
  def development_one
    @_d1 ||= Development.create!(
      id: 101_010, name: 'Gadfly Hotel',
      address: '505 Washington Street', city: 'Boston', state: 'MA',
      zip_code: '02111', status: 'in_construction', commsf: 12,
      estemp: 75, private: true,
      created_at: Time.new('1969-12-31 19:00:00 -0500'),
      updated_at: Time.new('1969-12-31 19:00:00 -0500'),
      year_compl: '2016', creator: users(:normal)
    )
    @_d1.team_memberships = [DevelopmentTeamMembership.create(
      development: @_d1, role: 'landlord', organization: organizations(:mapc)
    )]
    @_d1.save
    @_d1
  end

  def development_two
    @_d2 ||= Development.create!(
      id: 101_011, name: 'Hello',
      address: "It's me / I was wondering if after all these years",
      city: "you'd like to me", state: 'ET', zip_code: '02118',
      status: 'completed', commsf: 200, estemp: 1_000, private: false,
      created_at: Time.new('1969-12-31 19:00:00 -0500'),
      updated_at: Time.new('1969-12-31 19:00:00 -0500'), year_compl: '2012',
      creator: users(:tim)
    )
  end

  def serializer
    @_base ||= DevelopmentsSerializer.new([development_one, development_two])
  end
  alias_method :base, :serializer

  test '#developments' do
    refute_empty base.developments
  end

  test 'prevents empty developments' do
    assert_raises(ArgumentError) { DevelopmentsSerializer.new([]) }
  end

  test '#to_header' do
    assert_equal 1, development_one.team_memberships.count
    assert_equal 1, development_one.team_members.count
    assert_equal expected_header, base.to_header
  end

  test '#to_csv' do
    assert_respond_to base, :to_csv
    Time.stub :now, Time.at(0) do
      assert_equal expected_csv, base.to_csv
    end
  end

  test '#to_file' do
    skip
  end

  private

  def expected_csv
    <<-CSV
id,creator_id,created_at,updated_at,rdv,asofright,ovr55,clusteros,phased,stalled,name,status,desc,project_url,mapc_notes,tagline,address,city,state,zip_code,height,stories,year_compl,prjarea,singfamhu,twnhsmmult,lgmultifam,tothu,gqpop,rptdemp,emploss,estemp,commsf,hotelrms,onsitepark,total_cost,team_membership_count,cancelled,private,fa_ret,fa_ofcmd,fa_indmf,fa_whs,fa_rnd,fa_edinst,fa_other,fa_hotel,other_rate,affordable,latitude,longitude,team_member_1_name,team_member_1_website,team_member_1_url_template,team_member_1_location,team_member_1_email,team_member_1_abbv,team_member_1_short_name,team_member_1_role
101010,562391268,1969-01-01 05:00:00 UTC,1969-01-01 05:00:00 UTC,,,,,,,Gadfly Hotel,in_construction,,,,Luxury hotel with ground-floor retail.,505 Washington Street,Boston,MA,02111,,,2016,,,,,,,,,75,12,,,,1,false,true,,,,,,,,,,,,,Metropolitan Area Planning Council,http://mapc.org,,\"Boston, MA\",,MAPC,MAPC,landlord
101011,730190997,1969-01-01 05:00:00 UTC,1969-01-01 05:00:00 UTC,,,,,,,Hello,completed,,,,Luxury hotel with ground-floor retail.,It's me / I was wondering if after all these years,you'd like to me,ET,02118,,,2012,,,,,,,,,1000,200,,,,,false,false,,,,,,,,,,,,,,,,,,,,
    CSV
  end

  def expected_header
    %w( id creator_id created_at updated_at rdv asofright ovr55
        clusteros phased stalled name status desc project_url
        mapc_notes tagline address city state zip_code height
        stories year_compl prjarea singfamhu twnhsmmult lgmultifam
        tothu gqpop rptdemp emploss estemp commsf hotelrms
        onsitepark total_cost team_membership_count cancelled
        private fa_ret fa_ofcmd fa_indmf fa_whs fa_rnd fa_edinst
        fa_other fa_hotel other_rate affordable latitude longitude
        team_member_1_name team_member_1_website
        team_member_1_url_template team_member_1_location
        team_member_1_email team_member_1_abbv
        team_member_1_short_name team_member_1_role )
  end

end
