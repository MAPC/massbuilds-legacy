require 'test_helper'

class DevelopmentSerializerTest < ActiveSupport::TestCase

  def setup
    stub_street_view
  end

  def development
    @_d ||= Development.create!(
      id: 101_010,
      name:     'Gadfly Hotel',
      address:  '505 Washington Street',
      place:     places(:boston),
      state:    'MA',
      zip_code: '02111',
      status:   :planning,
      tothu:   1,
      commsf: 12,
      estemp: 75,
      latitude: 42,
      longitude: -71,
      private: true,
      created_at: Time.new('1969-12-31 19:00:00 -0500'),
      updated_at: Time.new('1969-12-31 19:00:00 -0500'),
      year_compl: 2016,
      creator: users(:normal)
    )
    @_d.team_memberships = [DevelopmentTeamMembership.create(
      development: @_d,
      role: 'landlord',
      organization: organizations(:mapc)
    )]
    @_d
  end

  def serializer
    @_base ||= DevelopmentSerializer.new(nil)
  end

  def serializer_with_development
    @_development ||= DevelopmentSerializer.new(development, max_team_size: 1)
  end

  def serializer_only
    @_only ||= DevelopmentSerializer.new(development, only: 'name')
  end

  def serializer_except
    @_e ||= DevelopmentSerializer.new(development, except: [:name, 'address'])
  end

  alias_method :base,   :serializer
  alias_method :dev,    :serializer_with_development
  alias_method :only,   :serializer_only
  alias_method :except, :serializer_except

  test '#to_row' do
    assert_respond_to base, :to_row
  end

  test '#to_row produces csv row of values' do
    Time.stub :now, Time.at(0) do
      assert_equal expected_row, dev.to_row
    end
  end

  test '#to_row includes development team' do
    assert_includes dev.to_row, 'landlord'
  end

  test '#to_header with an #attribute-less object' do
    assert_respond_to base, :to_header
    assert_equal [], base.to_header
  end

  test '#to_header with an object' do
    assert_equal expected_header, dev.to_header
  end

  test '#to_header shows development team' do
    assert_includes dev.to_header, 'team_member_1_name'
    assert_includes dev.to_header, 'team_member_1_role'
  end

  test 'can allow (only) certain attributes' do
    refute_includes ['505 Washington Street'], only.to_row
    refute_includes ['address'], only.to_header
  end

  test 'can block (except) attributes' do
    refute_includes except.to_row, 'Godfrey Hotel'
    refute_includes except.to_row, '505 Washington Street'
    refute_includes except.to_header, 'name'
  end

  private

  def expected_row
    [101010, 562391268, "1969-01-01 05:00:00 UTC", "1969-01-01 05:00:00 UTC",
     nil, nil, nil, nil, nil, nil, "Gadfly Hotel", "planning", nil, nil, nil,
     nil, "505 Washington Street", "MA", "02111", nil, nil, 2016, nil, nil,
     nil, nil, 1, nil, nil, nil, 0, 12, nil, nil, nil, nil, false, true, nil,
     nil, nil, nil, nil, nil, nil, nil, nil, nil, 42.0, -71.0, nil, true, nil,
     "Metropolitan Area Planning Council", "http://mapc.org", nil, "Boston, MA",
     nil, "MAPC", "MAPC", "landlord"]
  end

  def expected_header
    %w( id creator_id created_at updated_at rdv asofright ovr55
        clusteros phased stalled name status desc project_url
        mapc_notes tagline address state zip_code height
        stories year_compl prjarea singfamhu twnhsmmult lgmultifam
        tothu gqpop rptdemp emploss estemp commsf hotelrms
        onsitepark total_cost team_membership_count cancelled
        private fa_ret fa_ofcmd fa_indmf fa_whs fa_rnd fa_edinst
        fa_other fa_hotel other_rate affordable latitude longitude
        place_id mixed_use city team_member_1_name team_member_1_website
        team_member_1_url_template team_member_1_location
        team_member_1_email team_member_1_abbv
        team_member_1_short_name team_member_1_role )
  end

  def stub_street_view(lat: 42.0, lon: -71.0, heading: 35, pitch: 28)
    file = ActiveRecord::FixtureSet.file('street_view/godfrey.jpg')
    stub_request(:get, "http://maps.googleapis.com/maps/api/streetview?fov=100&heading=#{heading}&key=loLOLol&location=#{lat},#{lon}&pitch=#{pitch}&size=600x600").
      to_return(status: 200, body: file)
  end

  def stub_walkscore(lat: 42.000001, lon: 71.000001)
    file = File.read('test/fixtures/walkscore/200.json')
    stub_request(:get, "http://api.walkscore.com/score?format=json&lat=#{lat}&lon=#{lon}&wsapikey=").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'api.walkscore.com', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => file)
  end


end
