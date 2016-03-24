require 'test_helper'

class DevelopmentTeamSerializerTest < ActiveSupport::TestCase
  def serializer
    @_base ||= DevelopmentTeamSerializer.new(developments(:one), 1)
  end

  def nine_team_members
    @_niner ||= DevelopmentTeamSerializer.new(developments(:one), 9)
  end
  alias_method :base,  :serializer
  alias_method :niner, :nine_team_members

  test '#to_header' do
    assert_equal one_team_member_csv_header, base.to_header
  end

  test '#to_header with more projects' do
    header = niner.to_header
    assert_equal 72, header.compact.count # to avoid nils
    assert_equal 'team_member_1_name', header.first
    assert_equal 'team_member_9_role', header.last
  end

  test '#to_row' do
    assert_equal csv_row, base.to_row
  end

  test '#to_row with more projects' do
    row = niner.to_row
    assert_equal 72, row.count
    assert_equal 6, row.compact.count # there are 2 nil values
    assert_equal csv_row.first, row.first
    assert_equal nil, row.last
  end

  private

  def csv_row
    ['Metropolitan Area Planning Council', 'http://mapc.org', nil,
     'Boston, MA', nil, 'MAPC', 'MAPC', 'landlord']
  end

  def one_team_member_csv_header
    %w( team_member_1_name         team_member_1_website
        team_member_1_url_template team_member_1_location
        team_member_1_email        team_member_1_abbv
        team_member_1_short_name   team_member_1_role )
  end

end
